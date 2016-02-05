# Chef Provider for configuring an elasticsearch instance
class ElasticsearchCookbook::ConfigureProvider < Chef::Provider::LWRPBase
  include ElasticsearchCookbook::Helpers

  provides :elasticsearch_configure

  def whyrun_supported?
    false
  end

  action :manage do
    # lookup existing ES resources
    es_user = find_es_resource(run_context, :elasticsearch_user, new_resource)
    es_install = find_es_resource(run_context, :elasticsearch_install, new_resource)
    es_svc = find_es_resource(run_context, :elasticsearch_service, new_resource)

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
      malloc_str = (half > 30_500 ? '30500m' : "#{half}m")
      new_resource.allocated_memory malloc_str
    end

    # Create ES directories
    #
    [new_resource.path_conf[es_install.type], "#{new_resource.path_conf[es_install.type]}/scripts", new_resource.path_logs[es_install.type]].each do |path|
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

    # Valid values in /etc/sysconfig/elasticsearch or /etc/default/elasticsearch
    # ES_HOME CONF_DIR CONF_FILE DATA_DIR LOG_DIR WORK_DIR PID_DIR
    # ES_HEAP_SIZE ES_HEAP_NEWSIZE ES_DIRECT_SIZE ES_JAVA_OPTS
    # ES_RESTART_ON_UPGRADE ES_GC_LOG_FILE ES_STARTUP_SLEEP_TIME
    # ES_USER ES_GROUP MAX_OPEN_FILES MAX_LOCKED_MEMORY MAX_MAP_COUNT
    params = {}
    params[:ES_HOME] = new_resource.path_home[es_install.type]
    params[:CONF_DIR] = new_resource.path_conf[es_install.type]
    params[:DATA_DIR] = new_resource.path_data[es_install.type]
    params[:LOG_DIR] = new_resource.path_logs[es_install.type]
    params[:PID_DIR] = new_resource.path_pid[es_install.type]

    params[:ES_STARTUP_SLEEP_TIME] = new_resource.startup_sleep_seconds.to_s
    params[:ES_USER] = es_user.username
    params[:ES_GROUP] = es_user.groupname

    params[:JAVA_HOME] = new_resource.java_home
    params[:ES_HEAP_SIZE] = new_resource.allocated_memory
    params[:MAX_OPEN_FILES] = new_resource.nofile_limit
    params[:MAX_LOCKED_MEMORY] = new_resource.memlock_limit

    params[:ES_JAVA_OPTS] = ''
    params[:ES_JAVA_OPTS] << '-server '
    params[:ES_JAVA_OPTS] << '-Djava.awt.headless=true '
    params[:ES_JAVA_OPTS] << '-Djava.net.preferIPv4Stack=true '
    params[:ES_JAVA_OPTS] << "-Xms#{new_resource.allocated_memory} "
    params[:ES_JAVA_OPTS] << "-Xmx#{new_resource.allocated_memory} "
    params[:ES_JAVA_OPTS] << "-Xss#{new_resource.thread_stack_size} "
    params[:ES_JAVA_OPTS] << "#{new_resource.gc_settings.tr("\n", ' ')} " if new_resource.gc_settings
    params[:ES_JAVA_OPTS] << '-Dfile.encoding=UTF-8 '
    params[:ES_JAVA_OPTS] << '-Djna.nosys=true '
    params[:ES_JAVA_OPTS] << "#{new_resource.env_options} " if new_resource.env_options

    default_config_name = es_svc.service_name || es_svc.instance_name || new_resource.instance_name || 'elasticsearch'

    shell_template = template 'elasticsearch.in.sh' do
      path node['platform_family'] == 'rhel' ? "/etc/sysconfig/#{default_config_name}" : "/etc/default/#{default_config_name}"
      source new_resource.template_elasticsearch_env
      cookbook new_resource.cookbook_elasticsearch_env
      mode 0755
      variables(params: params)
      action :nothing
    end
    shell_template.run_action(:create)
    new_resource.updated_by_last_action(true) if shell_template.updated_by_last_action?

    # Create ES logging file
    #
    logging_template = template 'logging.yml' do
      path   "#{new_resource.path_conf[es_install.type]}/logging.yml"
      source new_resource.template_logging_yml
      cookbook new_resource.cookbook_logging_yml
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
      cookbook new_resource.cookbook_elasticsearch_yml
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
