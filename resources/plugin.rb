unified_mode true

include ElasticsearchCookbook::Helpers

property :plugin_name,
         String,
         name_property: true

property :url,
         String

property :options,
         String,
         default: ''

# this is what helps the various resources find each other
property :instance_name,
        String

action :install do
  execute "Install plugin #{new_resource.plugin_name}" do
    command "#{es_conf.path_bin}/elasticsearch-plugin install #{new_resource.options} #{config[:plugin_name]}".chomp(' ')
    not_if { plugin_exists? }
    environment env
    user config[:user] unless config[:install_type] == 'package' || config[:install_type] == 'repository'
    group config[:group] unless config[:install_type] == 'package' || config[:install_type] == 'repository'
  end
end

action :remove do
  execute "Remove plugin #{new_resource.plugin_name}" do
    command "#{es_conf.path_bin}/elasticsearch-plugin remove #{new_resource.options} #{config[:plugin_name]}".chomp(' ')
    only_if { plugin_exists? }
    environment env
    user config[:user] unless config[:install_type] == 'package' || config[:install_type] == 'repository'
    group config[:group] unless config[:install_type] == 'package' || config[:install_type] == 'repository'
  end
end

action_class do
  def es_user
    find_es_resource(Chef.run_context, :elasticsearch_user, new_resource)
  end

  def es_install
    find_es_resource(Chef.run_context, :elasticsearch_install, new_resource)
  end

  def es_conf
    find_es_resource(Chef.run_context, :elasticsearch_configure, new_resource)
  end

  def env
    include_file_resource = find_exact_resource(Chef.run_context, :template, "elasticsearch.in.sh-#{config[:name]}")
    { 'ES_INCLUDE' => include_file_resource.path }
  end

  def config
    {
      name: new_resource.instance_name || es_conf.instance_name || 'elasticsearch',
      plugin_name: new_resource.url || new_resource.plugin_name,
      install_type: es_install.type,
      user: es_user.username,
      group: es_user.groupname,
      path_conf: es_conf.path_conf,
      path_plugins: es_conf.path_plugins,
      path_bin: es_conf.path_bin,
    }
  end

  def plugin_exists?
    # This is quicker than shelling out to the plugin list command
    # The plugin install command checks for the existsance of the plugin directory anyway
    es_conf = find_es_resource(Chef.run_context, :elasticsearch_configure, new_resource)
    path = es_conf.path_plugins

    Dir.entries(path).any? do |plugin|
      next if plugin =~ /^\./
      config[:plugin_name] == plugin
    end
  rescue
    false
  end
end
