class Chef
  # Chef Provider for configuring an elasticsearch instance
  class Provider::ElasticsearchConfigure < Chef::Provider::LWRPBase
    include ElasticsearchCookbook::Helpers

    action :manage do
      converge_by('configure elasticsearch instance') do
        touched_resources = []

        # calculation for memory allocation; 50% or 31g, whatever is smaller
        unless new_resource.allocated_memory
          half = ((node.memory.total.to_i * 0.5 ).floor / 1024)
          new_resource.allocated_memory (half > 31000 ? "31g" : "#{half}m")
        end

        # Create ES directories
        #
        [ new_resource.path_conf, new_resource.path_logs ].each do |path|
          d = directory path do
            owner new_resource.user
            group new_resource.group
            mode 0755
            recursive true
            action :nothing
          end
          d.run_action(:create)
          new_resource.updated_by_last_action(true) if d.updated_by_last_action?
        end

        # Create data path directories
        #
        data_paths = new_resource.path_data.is_a?(Array) ? new_resource.path_data : new_resource.path_data.split(',')

        data_paths.each do |path|
          d = directory path.strip do
            owner new_resource.user
            group new_resource.group
            mode 0755
            recursive true
            action :nothing
          end
          d.run_action(:create)
          new_resource.updated_by_last_action(true) if d.updated_by_last_action?
        end

        shell_template = template "elasticsearch.in.sh" do
          path "#{new_resource.path_conf}/elasticsearch.in.sh"
          source new_resource.template_elasticsearch_env
          cookbook 'elasticsearch'
          owner new_resource.user
          group new_resource.group
          mode 0755
          variables({
            java_home: new_resource.java_home,
            es_home: new_resource.es_home,
            es_config: new_resource.path_conf,
            allocated_memory: new_resource.allocated_memory,
            Xms: new_resource.allocated_memory,
            Xmx: new_resource.allocated_memory,
            Xss: new_resource.thread_stack_size,
            gc_settings: new_resource.gc_settings,
            env_options: new_resource.env_options
            })
          action :nothing
        end
        shell_template.run_action(:create)
        new_resource.updated_by_last_action(true) if shell_template.updated_by_last_action?

        # Create ES logging file
        #
        logging_template = template "logging.yml" do
          path   "#{new_resource.path_conf}/logging.yml"
          source new_resource.template_logging_yml
          cookbook 'elasticsearch'
          owner new_resource.user
          group new_resource.group
          mode 0755
          variables({logging: new_resource.logging})
          action :nothing
        end
        logging_template.run_action(:create)
        new_resource.updated_by_last_action(true) if logging_template.updated_by_last_action?


        merged_configuration = new_resource.default_configuration.merge(new_resource.configuration)
        merged_configuration[:_seen] = {} # magic state variable for what we've seen in a config

        # warn if someone is using symbols. we don't support.
        found_symbols = merged_configuration.keys.select { |s| s.is_a?(Symbol) && s != :_seen }
        unless found_symbols.empty?
          Chef::Log.warn("Please change the following to strings in order to work with this Elasticsearch cookbook: #{found_symbols.join(',')}")
        end

        yml_template = template "elasticsearch.yml" do
          path "#{new_resource.path_conf}/elasticsearch.yml"
          source new_resource.template_elasticsearch_yml
          cookbook 'elasticsearch'
          owner new_resource.user
          group new_resource.group
          mode 0755
          helpers(ElasticsearchCookbook::Helpers)
          variables({
            config: merged_configuration
            })
          action :nothing
        end
        yml_template.run_action(:create)
        new_resource.updated_by_last_action(true) if yml_template.updated_by_last_action?
      end
    end
   end
 end
