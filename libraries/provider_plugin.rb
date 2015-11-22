# Chef Provider for installing an elasticsearch plugin
class ElasticsearchCookbook::PluginProvider < Chef::Provider::LWRPBase
  include ElasticsearchCookbook::Helpers
  include Chef::Mixin::ShellOut

  provides :elasticsearch_plugin

  def whyrun_supported?
    false
  end

  action :install do
    es_user = find_es_resource(run_context, :elasticsearch_user, new_resource)
    es_install = find_es_resource(run_context, :elasticsearch_install, new_resource)
    es_conf = find_es_resource(run_context, :elasticsearch_configure, new_resource)

    begin
      if es_user.username != 'root' && es_install.version.to_f < 2.0
        Chef::Log.warn("Elasticsearch < 2.0.0 (you are using #{es_install.version}) requires plugins be installed as root (you are using #{es_user.username})")
      end
    rescue
      Chef::Log.warn("Could not parse #{es_install.version} as floating point number")
    end

    name = new_resource.plugin_name
    url  = new_resource.url

    unless es_conf.path_plugins[es_install.type] # may not exist yet if first plugin
      fail "Could not determine the plugin directory (#{es_conf.path_plugins[es_install.type]}). Please check elasticsearch_configure[#{es_conf.name}]."
    end

    unless es_conf.path_bin[es_install.type] && ::File.exist?(es_conf.path_bin[es_install.type])
      fail "Could not determine the binary directory (#{es_conf.path_bin[es_install.type]}). Please check elasticsearch_configure[#{es_conf.name}]."
    end

    # shell_out! automatically raises on error, logs command output
    unless plugin_exists(es_conf.path_plugins[es_install.type], name)
      # required for package installs that show up with parent dir owned by root
      shell_out!("mkdir -p #{es_conf.path_plugins[es_install.type]}") unless ::File.exist?(es_conf.path_plugins[es_install.type])
      shell_out!("chown #{es_user.username}:#{es_user.groupname} #{es_conf.path_plugins[es_install.type]}")

      # do the actual install
      shell_out!("#{es_conf.path_bin[es_install.type]}/plugin install #{url}".split(' '), user: es_user.username, group: es_user.groupname)

      new_resource.updated_by_last_action(true)
    end
  end # action

  action :remove do
    es_user = find_es_resource(run_context, :elasticsearch_user, new_resource)
    es_install = find_es_resource(run_context, :elasticsearch_install, new_resource)
    es_conf = find_es_resource(run_context, :elasticsearch_configure, new_resource)

    name    = new_resource.plugin_name

    fail 'Could not determine the plugin directory. Please set plugin_dir on this resource.' unless new_resource.plugin_dir[es_install.type]
    if plugin_exists(es_conf.path_plugins[es_install.type], name)
      # automatically raises on error, logs command output
      shell_out!("#{new_resource.path_bin[es_install.type]}/plugin -remove #{name}".split(' '), user: es_user.username, group: es_user.groupname)
      new_resource.updated_by_last_action(true)
    end
  end # action

  def plugin_exists(path, name)
    Dir.entries(path).any? do |plugin|
      next if plugin =~ /^\./
      name.include? plugin
    end
  rescue
    false
  end
end # provider
