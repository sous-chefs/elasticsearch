# Chef Resource for configuring an Elasticsearch node
class ElasticsearchCookbook::ConfigureResource < Chef::Resource::LWRPBase
  resource_name :elasticsearch_configure
  provides :elasticsearch_configure

  actions(:manage, :remove)
  default_action :manage

  # this is what helps the various resources find each other
  attribute(:instance_name, kind_of: String, default: nil)

  # if you override one of these, you should probably override them all
  attribute(:path_home,    kind_of: String, default: '/usr/share/elasticsearch')
  attribute(:path_conf,    kind_of: String, default: '/etc/elasticsearch')
  attribute(:path_data,    kind_of: String, default: '/var/lib/elasticsearch')
  attribute(:path_logs,    kind_of: String, default: '/var/log/elasticsearch')
  attribute(:path_pid,     kind_of: String, default: '/var/run/elasticsearch')
  attribute(:path_plugins, kind_of: String, default: '/usr/share/elasticsearch/plugins')
  attribute(:path_bin,     kind_of: String, default: '/usr/share/elasticsearch/bin')

  attribute(:template_elasticsearch_env, kind_of: String, default: 'elasticsearch.in.sh.erb')
  attribute(:cookbook_elasticsearch_env, kind_of: String, default: 'elasticsearch')

  attribute(:template_jvm_options, kind_of: String, default: 'jvm_options.erb')
  attribute(:cookbook_jvm_options, kind_of: String, default: 'elasticsearch')

  attribute(:template_elasticsearch_yml, kind_of: String, default: 'elasticsearch.yml.erb')
  attribute(:cookbook_elasticsearch_yml, kind_of: String, default: 'elasticsearch')

  attribute(:template_log4j2_properties, kind_of: String, default: 'log4j2.properties.erb')
  attribute(:cookbook_log4j2_properties, kind_of: String, default: 'elasticsearch')

  attribute(:logging, kind_of: Hash, default: {}.freeze)
  attribute(:java_home, kind_of: String, default: nil)

  # other settings in /etc/default or /etc/sysconfig
  attribute(:memlock_limit, kind_of: String, default: 'unlimited')
  attribute(:max_map_count, kind_of: String, default: '262144')
  attribute(:nofile_limit, kind_of: String, default: '65536')
  attribute(:startup_sleep_seconds, kind_of: [String, Integer], default: 5)
  attribute(:restart_on_upgrade, kind_of: [TrueClass, FalseClass], default: false)

  # Calculations for this are done in the provider, as we can't do them in the
  # resource definition. default is 50% of RAM or 31GB, which ever is smaller.
  attribute(:allocated_memory, kind_of: String)

  attribute(:jvm_options, kind_of: Array, default:
    %w(
      -XX:+UseConcMarkSweepGC
      -XX:CMSInitiatingOccupancyFraction=75
      -XX:+UseCMSInitiatingOccupancyOnly
      -XX:+AlwaysPreTouch
      -server
      -Xss1m
      -Djava.awt.headless=true
      -Dfile.encoding=UTF-8
      -Djna.nosys=true
      -XX:-OmitStackTraceInFastThrow
      -Dio.netty.noUnsafe=true
      -Dio.netty.noKeySetOptimization=true
      -Dio.netty.recycler.maxCapacityPerThread=0
      -Dlog4j.shutdownHookEnabled=false
      -Dlog4j2.disable.jmx=true
      -XX:+HeapDumpOnOutOfMemoryError
    ).freeze)

  # These are the default settings. Most of the time, you want to override
  # the `configuration` attribute below. If you do override the defaults, you
  # must supply ALL needed defaults, and don't use nil as a value in the hash.
  attribute(:default_configuration, kind_of: Hash, default: {
    # === NAMING
    'cluster.name' => 'elasticsearch',
    # can't access node.name, so expect to have to set set this
    'node.name' => Chef::Config[:node_name],

    # if omitted or nil, these will be populated from attributes above
    'path.data' => nil, # see path_data above
    'path.logs' => nil, # see path_logs above

    # Refer to ES documentation on how to configure these to a
    # specific node role/type instead of using the defaults
    #
    # 'node.data' => ?,
    # 'node.master' => ?,
  }.freeze)

  # These settings are merged with the `default_configuration` attribute,
  # allowing you to override and set specific settings. Unless you intend to
  # wipe out all default settings, your configuration items should go here.
  #
  attribute(:configuration, kind_of: Hash, default: {}.freeze)
end
