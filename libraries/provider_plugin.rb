# Chef Provider for installing an elasticsearch plugin
class ElasticsearchCookbook::PluginProvider < Chef::Provider::LWRPBase
  include ElasticsearchCookbook::Helpers
  include Chef::Mixin::ShellOut

  provides :elasticsearch_plugin

  use_inline_resources if defined?(use_inline_resources)

  def whyrun_supported?
    false
  end

  action :install do
    unless plugin_exists(new_resource.plugin_name)
      # respect chef proxy settings unless they have been disabled explicitly
      proxy_arguments = get_java_proxy_arguments(new_resource.chef_proxy)
      manage_plugin("install #{new_resource.url} #{proxy_arguments}")
    end
  end # action

  action :remove do
    if plugin_exists(new_resource.plugin_name)
      manage_plugin("remove #{new_resource.plugin_name}")
    end
  end # action

  def manage_plugin(arguments)
    es_user = find_es_resource(run_context, :elasticsearch_user, new_resource)
    es_install = find_es_resource(run_context, :elasticsearch_install, new_resource)
    es_conf = find_es_resource(run_context, :elasticsearch_configure, new_resource)

    assert_state_is_valid(es_user, es_install, es_conf)

    # shell_out! automatically raises on error, logs command output
    # required for package installs that show up with parent dir owned by root
    plugin_dir_exists = ::File.exist?(es_conf.path_plugins[es_install.type])
    shell_out_as_user!("mkdir -p #{es_conf.path_plugins[es_install.type]}", run_context) unless plugin_dir_exists

    command_array = "#{es_conf.path_bin[es_install.type]}/plugin #{arguments.chomp(' ')}".chomp(' ').split(' ')
    shell_out_as_user!(command_array, run_context)
    new_resource.updated_by_last_action(true)
  end

  def plugin_exists(name)
    es_install = find_es_resource(run_context, :elasticsearch_install, new_resource)
    es_conf = find_es_resource(run_context, :elasticsearch_configure, new_resource)
    path = es_conf.path_plugins[es_install.type]

    Dir.entries(path).any? do |plugin|
      next if plugin =~ /^\./
      name.include? plugin
    end
  rescue
    false
  end

  def assert_state_is_valid(es_user, es_install, es_conf)
    begin
      if es_user.username != 'root' && es_install.version.to_f < 2.0
        Chef::Log.warn("Elasticsearch < 2.0.0 (you are using #{es_install.version}) requires plugins be installed as root (you are using #{es_user.username})")
      end
    rescue
      Chef::Log.warn("Could not parse #{es_install.version} as floating point number")
    end

    unless es_conf.path_plugins[es_install.type] # we do not check existence (may not exist if no plugins installed)
      raise "Could not determine the plugin directory (#{es_conf.path_plugins[es_install.type]}). Please check elasticsearch_configure[#{es_conf.name}]."
    end

    unless es_conf.path_bin[es_install.type] && ::File.exist?(es_conf.path_bin[es_install.type])
      raise "Could not determine the binary directory (#{es_conf.path_bin[es_install.type]}). Please check elasticsearch_configure[#{es_conf.name}]."
    end

    return true
  end

  def shell_out_as_user!(command, run_ctx)
    es_install = find_es_resource(run_ctx, :elasticsearch_install, new_resource)

    # See this link for an explanation:
    # https://www.elastic.co/guide/en/elasticsearch/plugins/2.1/plugin-management.html
    if es_install.type == :package
      # package installations should install plugins as root
      shell_out!(command)
    else
      # non-package installations should install plugins as the ES user
      es_user = find_es_resource(run_ctx, :elasticsearch_user, new_resource)
      shell_out!(command, user: es_user.username, group: es_user.groupname)
    end
  end
end # provider
