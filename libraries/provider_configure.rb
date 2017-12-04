# Chef Provider for configuring an elasticsearch instance
class ElasticsearchCookbook::ConfigureProvider < Chef::Provider::LWRPBase
  include ElasticsearchCookbook::Helpers

  provides :elasticsearch_configure

  def whyrun_supported?
    true # we only use core Chef resources that also support whyrun
  end

  def action_manage
    # lookup existing ES resources
    es_user = find_es_resource(Chef.run_context, :elasticsearch_user, new_resource)
    es_svc = find_es_resource(Chef.run_context, :elasticsearch_service, new_resource)

    default_configuration = new_resource.default_configuration.dup
    # if a subdir parameter is missing but dir is set, infer the subdir name
    # then go and be sure it's also set in the YML hash if it wasn't given there
    if new_resource.path_data && default_configuration['path.data'].nil?
      default_configuration['path.data'] = new_resource.path_data
    end

    if new_resource.path_logs && default_configuration['path.logs'].nil?
      default_configuration['path.logs'] = new_resource.path_logs
    end

    # calculation for memory allocation; 50% or 31g, whatever is smaller
    unless new_resource.allocated_memory
      half = ((node['memory']['total'].to_i * 0.5).floor / 1024)
      malloc_str = (half > 30_500 ? '30500m' : "#{half}m")
      new_resource.allocated_memory malloc_str
    end

    # Create ES directories
    #
    [new_resource.path_conf, "#{new_resource.path_conf}/scripts"].each do |path|
      d = directory path do
        owner es_user.username
        group es_user.groupname
        mode '0750'
        recursive true
        action :nothing
      end
      d.run_action(:create)
      new_resource.updated_by_last_action(true) if d.updated_by_last_action?
    end

    # Create data path directories
    #
    data_paths = new_resource.path_data.is_a?(Array) ? new_resource.path_data : new_resource.path_data.split(',')
    data_paths = data_paths << new_resource.path_logs

    data_paths.each do |path|
      d = directory path.strip do
        owner es_user.username
        group es_user.groupname
        mode '0755'
        recursive true
        action :nothing
      end
      d.run_action(:create)
      new_resource.updated_by_last_action(true) if d.updated_by_last_action?
    end

    # Create elasticsearch shell variables file
    #
    # Valid values in /etc/sysconfig/elasticsearch or /etc/default/elasticsearch
    # ES_HOME JAVA_HOME ES_PATH_CONF DATA_DIR LOG_DIR PID_DIR ES_JAVA_OPTS
    # RESTART_ON_UPGRADE ES_USER ES_GROUP ES_STARTUP_SLEEP_TIME MAX_OPEN_FILES
    # MAX_LOCKED_MEMORY MAX_MAP_COUNT
    #
    # We provide these values as resource attributes/parameters directly

    params = {}
    params[:ES_HOME] = new_resource.path_home
    params[:JAVA_HOME] = new_resource.java_home
    params[:ES_PATH_CONF] = new_resource.path_conf
    params[:DATA_DIR] = new_resource.path_data
    params[:LOG_DIR] = new_resource.path_logs
    params[:PID_DIR] = new_resource.path_pid
    params[:RESTART_ON_UPGRADE] = new_resource.restart_on_upgrade
    params[:ES_USER] = es_user.username
    params[:ES_GROUP] = es_user.groupname
    params[:ES_STARTUP_SLEEP_TIME] = new_resource.startup_sleep_seconds.to_s
    params[:MAX_OPEN_FILES] = new_resource.nofile_limit
    params[:MAX_LOCKED_MEMORY] = new_resource.memlock_limit
    params[:MAX_MAP_COUNT] = new_resource.max_map_count

    default_config_name = es_svc.service_name || es_svc.instance_name || new_resource.instance_name || 'elasticsearch'

    shell_template = template "elasticsearch.in.sh-#{default_config_name}" do
      path node['platform_family'] == 'rhel' ? "/etc/sysconfig/#{default_config_name}" : "/etc/default/#{default_config_name}"
      source new_resource.template_elasticsearch_env
      cookbook new_resource.cookbook_elasticsearch_env
      mode '0644'
      variables(params: params)
      action :nothing
    end
    shell_template.run_action(:create)
    new_resource.updated_by_last_action(true) if shell_template.updated_by_last_action?

    # Create jvm.options file
    #
    jvm_options_template = template "jvm_options-#{default_config_name}" do
      path   "#{new_resource.path_conf}/jvm.options"
      source new_resource.template_jvm_options
      cookbook new_resource.cookbook_jvm_options
      owner es_user.username
      group es_user.groupname
      mode '0644'
      variables(jvm_options: [
        "-Xms#{new_resource.allocated_memory}",
        "-Xmx#{new_resource.allocated_memory}",
        new_resource.jvm_options,
      ].flatten.join("\n"))
      action :nothing
    end
    jvm_options_template.run_action(:create)
    new_resource.updated_by_last_action(true) if jvm_options_template.updated_by_last_action?

    # Create ES logging file
    #
    logging_template = template "log4j2_properties-#{default_config_name}" do
      path   "#{new_resource.path_conf}/log4j2.properties"
      source new_resource.template_log4j2_properties
      cookbook new_resource.cookbook_log4j2_properties
      owner es_user.username
      group es_user.groupname
      mode '0640'
      variables(logging: new_resource.logging)
      action :nothing
    end
    logging_template.run_action(:create)
    new_resource.updated_by_last_action(true) if logging_template.updated_by_last_action?

    # Create ES elasticsearch.yml file
    #
    merged_configuration = default_configuration.merge(new_resource.configuration.dup)

    # warn if someone is using symbols. we don't support.
    found_symbols = merged_configuration.keys.select { |s| s.is_a?(Symbol) }
    unless found_symbols.empty?
      Chef::Log.warn("Please change the following to strings in order to work with this Elasticsearch cookbook: #{found_symbols.join(',')}")
    end

    # workaround for https://github.com/elastic/cookbook-elasticsearch/issues/590
    config_vars = ElasticsearchCookbook::HashAndMashBlender.new(merged_configuration).to_hash

    yml_template = template "elasticsearch.yml-#{default_config_name}" do
      path "#{new_resource.path_conf}/elasticsearch.yml"
      source new_resource.template_elasticsearch_yml
      cookbook new_resource.cookbook_elasticsearch_yml
      owner es_user.username
      group es_user.groupname
      mode '0640'
      helpers(ElasticsearchCookbook::Helpers)
      variables(config: config_vars)
      action :nothing
    end
    yml_template.run_action(:create)
    new_resource.updated_by_last_action(true) if yml_template.updated_by_last_action?
  end
end
