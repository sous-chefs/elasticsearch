# Chef Resource for configuring an Elasticsearch node
class ElasticsearchCookbook::ConfigureResource < Chef::Resource::LWRPBase
  resource_name :elasticsearch_configure
  provides :elasticsearch_configure

  actions(:manage, :remove)
  default_action :manage

  # this is what helps the various resources find each other
  attribute(:instance_name, kind_of: String, default: nil)

  # if you override one of these, you should probably override them all
  attribute(:path_home, kind_of: Hash, default: {
              package: '/usr/share/elasticsearch',
              tarball: '/usr/local/elasticsearch'
            })
  attribute(:path_conf, kind_of: Hash, default: {
              package: '/etc/elasticsearch',
              tarball: '/usr/local/etc/elasticsearch'
            })
  attribute(:path_data, kind_of: Hash, default: {
              package: '/usr/share/elasticsearch',
              tarball: '/usr/local/var/data/elasticsearch'
            })
  attribute(:path_logs, kind_of: Hash, default: {
              package: '/var/log/elasticsearch',
              tarball: '/usr/local/var/log/elasticsearch'
            })
  attribute(:path_pid, kind_of: Hash, default: {
              package: '/var/run/elasticsearch',
              tarball: '/usr/local/var/run'
            })
  attribute(:path_plugins, kind_of: Hash, default: {
              package: '/usr/share/elasticsearch/plugins',
              tarball: '/usr/local/elasticsearch/plugins'
            })
  attribute(:path_bin, kind_of: Hash, default: {
              package: '/usr/share/elasticsearch/bin',
              tarball: '/usr/local/bin'
            })

  attribute(:template_elasticsearch_env, kind_of: String, default: 'elasticsearch.in.sh.erb')
  attribute(:cookbook_elasticsearch_env, kind_of: String, default: 'elasticsearch')

  attribute(:template_elasticsearch_yml, kind_of: String, default: 'elasticsearch.yml.erb')
  attribute(:cookbook_elasticsearch_yml, kind_of: String, default: 'elasticsearch')

  attribute(:template_logging_yml, kind_of: String, default: 'logging.yml.erb')
  attribute(:cookbook_logging_yml, kind_of: String, default: 'elasticsearch')

  attribute(:logging, kind_of: Hash, default: {})

  attribute(:java_home, kind_of: String, default: nil)

  attribute(:startup_sleep_seconds, kind_of: [String, Integer], default: 5)

  # Calculations for this are done in the provider, as we can't do them in the
  # resource definition. default is 50% of RAM or 31GB, which ever is smaller.
  attribute(:allocated_memory, kind_of: String)

  attribute(:thread_stack_size, kind_of: String, default: '256k')
  attribute(:env_options, kind_of: String, default: '')
  attribute(:gc_settings, kind_of: String, default:
    <<-CONFIG
     -XX:+UseParNewGC
     -XX:+UseConcMarkSweepGC
     -XX:CMSInitiatingOccupancyFraction=75
     -XX:+UseCMSInitiatingOccupancyOnly
     -XX:+HeapDumpOnOutOfMemoryError
     -XX:+DisableExplicitGC
    CONFIG
           )

  # default user limits
  attribute(:memlock_limit, kind_of: String, default: 'unlimited')
  attribute(:nofile_limit, kind_of: String, default: '64000')

  # These are the default settings. Most of the time, you want to override
  # the `configuration` attribute below. If you do override the defaults, you
  # must supply ALL needed defaults, and don't use nil as a value in the hash.
  attribute(:default_configuration, kind_of: Hash, default: {
              # === NAMING
              'cluster.name' => 'elasticsearch',
              # can't access node.name, so expect to have to set set this
              'node.name' => Chef::Config[:node_name],

              # if omitted or nil, these will be populated from attributes above
              'path.conf' => nil, # see path_conf above
              'path.data' => nil, # see path_data above
              'path.logs' => nil, # see path_logs above

              # Refer to ES documentation on how to configure these to a
              # specific node role/type instead of using the defaults
              #
              # 'node.data' => ?,
              # 'node.master' => ?,

              'action.destructive_requires_name' => true,
              'node.max_local_storage_nodes' => 1,

              'discovery.zen.ping.multicast.enabled' => true,
              'discovery.zen.minimum_master_nodes' => 1,
              'gateway.expected_nodes' => 0,

              'http.port' => 9200
            })

  # These settings are merged with the `default_configuration` attribute,
  # allowing you to override and set specific settings. Unless you intend to
  # wipe out all default settings, your configuration items should go here.
  #
  attribute(:configuration, kind_of: Hash, default: {})
end
