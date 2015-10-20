# Chef Provider for configuring an elasticsearch instance
class ElasticsearchCookbook::ConfigureProvider < Chef::Provider::LWRPBase
  include ElasticsearchCookbook::Helpers

  provides :elasticsearch_configure

  action :manage do
    converge_by('configure elasticsearch instance') do
      es_install = find_es_resource(run_context, :elasticsearch_install, new_resource)

      # if a subdir parameter is missing but dir is set, infer the subdir name
      # then go and be sure it's also set in the YML hash if it wasn't given there
      if new_resource.path_conf[es_install.type] && new_resource.default_configuration['path.conf'].nil?
        new_resource.default_configuration['path.conf'] = new_resource.path_conf[es_install.type]
      end

      if new_resource.path_data[es_install.type] && new_resource.default_configuration['path.data'].nil?
        new_resource.default_configuration['path.data'] = new_resource.path_data[es_install.type]
      end

      if new_resource.path_logs[es_install.type] && new_resource.default_configuration['path.logs'].nil?
        new_resource.default_configuration['path.logs'] = new_resource.path_logs[es_install.type]
      end

      # calculation for memory allocation; 50% or 31g, whatever is smaller
      unless new_resource.allocated_memory
        half = ((node['memory']['total'].to_i * 0.5).floor / 1024)
        malloc_str = (half > 31_000 ? '31g' : "#{half}m")
        new_resource.allocated_memory malloc_str
      end

      # lookup existing user resource
      es_user = find_es_resource(run_context, :elasticsearch_user, new_resource)

      # Create ES directories
      #
      [new_resource.path_conf[es_install.type], new_resource.path_logs[es_install.type]].each do |path|
        d = directory path do
          owner es_user.username
          group es_user.groupname
          mode 0755
          recursive true
          action :nothing
        end
        d.run_action(:create)
        new_resource.updated_by_last_action(true) if d.updated_by_last_action?
      end

      # Create data path directories
      #
      data_paths = new_resource.path_data[es_install.type].is_a?(Array) ? new_resource.path_data[es_install.type] : new_resource.path_data[es_install.type].split(',')

      data_paths.each do |path|
        d = directory path.strip do
          owner es_user.username
          group es_user.groupname
          mode 0755
          recursive true
          action :nothing
        end
        d.run_action(:create)
        new_resource.updated_by_last_action(true) if d.updated_by_last_action?
      end

      shell_template = template 'elasticsearch.in.sh' do
        path "#{new_resource.path_conf[es_install.type]}/elasticsearch.in.sh"
        source new_resource.template_elasticsearch_env
        cookbook 'elasticsearch'
        owner es_user.username
        group es_user.groupname
        mode 0755
        variables(java_home: new_resource.java_home,
                  es_home: es_user.homedir,
                  es_config: new_resource.path_conf[es_install.type],
                  allocated_memory: new_resource.allocated_memory,
                  Xms: new_resource.allocated_memory,
                  Xmx: new_resource.allocated_memory,
                  Xss: new_resource.thread_stack_size,
                  gc_settings: new_resource.gc_settings,
                  env_options: new_resource.env_options)
        action :nothing
      end
      shell_template.run_action(:create)
      new_resource.updated_by_last_action(true) if shell_template.updated_by_last_action?

      # Create ES logging file
      #
      logging_template = template 'logging.yml' do
        path   "#{new_resource.path_conf[es_install.type]}/logging.yml"
        source new_resource.template_logging_yml
        cookbook 'elasticsearch'
        owner es_user.username
        group es_user.groupname
        mode 0755
        variables(logging: new_resource.logging)
        action :nothing
      end
      logging_template.run_action(:create)
      new_resource.updated_by_last_action(true) if logging_template.updated_by_last_action?

      merged_configuration = new_resource.default_configuration.merge(new_resource.configuration)
      merged_configuration['#_seen'] = {} # magic state variable for what we've seen in a config

      # warn if someone is using symbols. we don't support.
      found_symbols = merged_configuration.keys.select { |s| s.is_a?(Symbol) }
      unless found_symbols.empty?
        Chef::Log.warn("Please change the following to strings in order to work with this Elasticsearch cookbook: #{found_symbols.join(',')}")
      end

      yml_template = template 'elasticsearch.yml' do
        path "#{new_resource.path_conf[es_install.type]}/elasticsearch.yml"
        source new_resource.template_elasticsearch_yml
        cookbook 'elasticsearch'
        owner es_user.username
        group es_user.groupname
        mode 0755
        helpers(ElasticsearchCookbook::Helpers)
        variables(config: merged_configuration)
        action :nothing
      end
      yml_template.run_action(:create)
      new_resource.updated_by_last_action(true) if yml_template.updated_by_last_action?
    end
  end
end
