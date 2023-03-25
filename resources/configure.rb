unified_mode true
# this is what helps the various resources find each other
property :instance_name, String

# If you override one of these, you should probably override them all
property :path_home,    String, default: '/usr/share/elasticsearch'
property :path_conf,    String, default: '/etc/elasticsearch'
property :path_data,    [String, Array], default: '/var/lib/elasticsearch'
property :path_logs,    String, default: '/var/log/elasticsearch'
property :path_pid,     String, default: '/var/run/elasticsearch'
property :path_plugins, String, default: '/usr/share/elasticsearch/plugins'
property :path_bin,     String, default: '/usr/share/elasticsearch/bin'

property :template_elasticsearch_env, String, default: 'elasticsearch.in.sh.erb'
property :cookbook_elasticsearch_env, String, default: 'elasticsearch'

property :template_jvm_options, String, default: 'jvm_options.erb'
property :cookbook_jvm_options, String, default: 'elasticsearch'

property :template_elasticsearch_yml, String, default: 'elasticsearch.yml.erb'
property :cookbook_elasticsearch_yml, String, default: 'elasticsearch'

property :template_log4j2_properties, String, default: 'log4j2.properties.erb'
property :cookbook_log4j2_properties, String, default: 'elasticsearch'

property :logging, Hash, default: {}.freeze
property :java_home, String

# other settings in /etc/default or /etc/sysconfig
property :memlock_limit, String, default: 'unlimited'
property :max_map_count, String, default: '262144'
property :nofile_limit, String, default: '65535'
property :startup_sleep_seconds, [String, Integer], default: 5
property :restart_on_upgrade, [true, false], default: false

# Calculations for this are done in the provider, as we can't do them in the
# resource definition. default is 50% of RAM or 31GB, which ever is smaller.
property :allocated_memory, String

property :jvm_options, Array, default:
  %w(
    8-13:-XX:+UseConcMarkSweepGC
    8-13:-XX:CMSInitiatingOccupancyFraction=75
    8-13:-XX:+UseCMSInitiatingOccupancyOnly
    14-:-XX:+UseG1GC
    -Djava.io.tmpdir=${ES_TMPDIR}
    -XX:+HeapDumpOnOutOfMemoryError
    9-:-XX:+ExitOnOutOfMemoryError
    -XX:ErrorFile=/var/log/elasticsearch/hs_err_pid%p.log
    8:-XX:+PrintGCDetails
    8:-XX:+PrintGCDateStamps
    8:-XX:+PrintTenuringDistribution
    8:-XX:+PrintGCApplicationStoppedTime
    8:-Xloggc:/var/log/elasticsearch/gc.log
    8:-XX:+UseGCLogFileRotation
    8:-XX:NumberOfGCLogFiles=32
    8:-XX:GCLogFileSize=64m
    9-:-Xlog:gc*,gc+age=trace,safepoint:file=/var/log/elasticsearch/gc.log:utctime,pid,tags:filecount=32,filesize=64m
  ).freeze

# These are the default settings. Most of the time, you want to override
# the `configuration` attribute below. If you do override the defaults, you
# must supply ALL needed defaults, and don't use nil as a value in the hash.
property :default_configuration, Hash, default: {
  'cluster.name' => 'elasticsearch',
  'node.name' => Chef::Config[:node_name],
}

# These settings are merged with the `default_configuration` attribute,
# allowing you to override and set specific settings. Unless you intend to
# wipe out all default settings, your configuration items should go here.
#
property :configuration, Hash, default: {}

include ElasticsearchCookbook::Helpers

action :manage do
  # lookup existing ES resources
  es_user = find_es_resource(Chef.run_context, :elasticsearch_user, new_resource)
  es_svc = find_es_resource(Chef.run_context, :elasticsearch_service, new_resource)
  es_install = find_es_resource(Chef.run_context, :elasticsearch_install, new_resource)

  default_configuration = new_resource.default_configuration.dup
  # if a subdir parameter is missing but dir is set, infer the subdir name
  # then go and be sure it's also set in the YML hash if it wasn't given there
  if new_resource.path_data && default_configuration['path.data'].nil?
    default_configuration['path.data'] = new_resource.path_data
  end

  if new_resource.path_logs && default_configuration['path.logs'].nil?
    default_configuration['path.logs'] = new_resource.path_logs
  end

  # Calculation for memory allocation; 50% or 31g, whatever is smaller
  #
  unless new_resource.allocated_memory
    half = ((node['memory']['total'].to_i * 0.5).floor / 1024)
    malloc_str = (half > 30_500 ? '30500m' : "#{half}m")
    new_resource.allocated_memory malloc_str
  end

  # Create ES directories
  #
  [new_resource.path_conf, "#{new_resource.path_conf}/scripts"].each do |path|
    directory path do
      owner es_user.username
      group es_user.groupname
      mode '0750'
      recursive true
      action :create
    end
  end

  directory new_resource.path_data do
    owner es_user.username
    group es_user.groupname
    mode '0750'
    recursive true
    action :create
  end

  if new_resource.path_data.is_a?(String)
    directory new_resource.path_data do
      owner es_user.username
      group es_user.groupname
      mode '0755'
      recursive true
      action :create
    end
  else
    new_resource.path_data.each do |path|
      directory path.strip do
        owner es_user.username
        group es_user.groupname
        mode '0755'
        recursive true
        action :create
      end
    end
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
  params[:ES_USER] = es_user.username if es_install.type == 'tarball'
  params[:ES_GROUP] = es_user.groupname if es_install.type == 'tarball'
  params[:ES_STARTUP_SLEEP_TIME] = new_resource.startup_sleep_seconds.to_s
  params[:MAX_OPEN_FILES] = new_resource.nofile_limit
  params[:MAX_LOCKED_MEMORY] = new_resource.memlock_limit
  params[:MAX_MAP_COUNT] = new_resource.max_map_count

  default_config_name = es_svc.service_name || es_svc.instance_name || new_resource.instance_name || 'elasticsearch'

  with_run_context :root do
    template "elasticsearch.in.sh-#{default_config_name}" do
      path platform_family?('rhel', 'amazon') ? "/etc/sysconfig/#{default_config_name}" : "/etc/default/#{default_config_name}"
      source new_resource.template_elasticsearch_env
      cookbook new_resource.cookbook_elasticsearch_env
      mode '0644'
      variables(params: params)
      action :create
    end
  end

  template "jvm_options-#{default_config_name}" do
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
    action :create
  end

  template "log4j2_properties-#{default_config_name}" do
    path   "#{new_resource.path_conf}/log4j2.properties"
    source new_resource.template_log4j2_properties
    cookbook new_resource.cookbook_log4j2_properties
    owner es_user.username
    group es_user.groupname
    mode '0640'
    variables(logging: new_resource.logging)
    action :create
  end

  # Create ES elasticsearch.yml file
  #
  merged_configuration = default_configuration.merge(new_resource.configuration.dup)

  # Warn if someone is using symbols. We don't support.
  found_symbols = merged_configuration.keys.select { |s| s.is_a?(Symbol) }
  unless found_symbols.empty?
    Chef::Log.warn("Please change the following to strings in order to work with this Elasticsearch cookbook: #{found_symbols.join(',')}")
  end

  # workaround for https://github.com/sous-chefs/elasticsearch/issues/590
  config_vars = ElasticsearchCookbook::HashAndMashBlender.new(merged_configuration).to_hash

  with_run_context :root do
    template "elasticsearch.yml-#{default_config_name}" do
      path "#{new_resource.path_conf}/elasticsearch.yml"
      source new_resource.template_elasticsearch_yml
      cookbook new_resource.cookbook_elasticsearch_yml
      owner es_user.username
      group es_user.groupname
      mode '0640'
      helpers(ElasticsearchCookbook::Helpers)
      variables(config: config_vars)
      action :create
    end
  end
end
