require 'poise'

class Chef
  # Chef Resource for configuring an elasticsearch instance
  class Resource::ElasticsearchConfigure < Resource
    include Poise

    actions(:manage, :remove)

    attribute(:dir, kind_of: String, default: "/usr/local")
    attribute(:path_conf, kind_of: String, default: lazy { "#{dir}/etc/elasticsearch" })
    attribute(:path_data, kind_of: String, default: lazy { "#{dir}/var/data/elasticsearch" })
    attribute(:path_logs, kind_of: String, default: lazy { "#{dir}/var/log/elasticsearch" })

    attribute(:user, kind_of: String, default: 'elasticsearch')
    attribute(:group, kind_of: String, default: 'elasticsearch')

    attribute(:template_elasticsearch_env, kind_of: String, default: 'elasticsearch-env.sh.erb')
    attribute(:template_elasticsearch_yml, kind_of: String, default: 'elasticsearch.yml.erb')
    attribute(:template_logging_yml, kind_of: String, default: 'logging.yml.erb')

    attribute(:logging, kind_of: Hash, default: {
      :"action" => 'DEBUG',
      :"com.amazonaws" => 'WARN',
      :"index.search.slowlog" => 'TRACE, index_search_slow_log_file',
      :"index.indexing.slowlog" => 'TRACE, index_indexing_slow_log_file'
      })

    # environment variables; if nil, we don't use
    attribute(:java_home, kind_of: String, default: nil)
    attribute(:es_home, kind_of: String, default: lazy { dir })
    attribute(:jmx, default: nil)
    attribute(:java_rmi_server_hostname, default: lazy { node[:ipaddress] })

    attribute(:allocated_memory, kind_of: String, default: lazy { "#{(node.memory.total.to_i * 0.6 ).floor / 1024}m" } )
    attribute(:thread_stack_size, kind_of: String, default: "256k")
    attribute(:env_options, kind_of: String, default: '')
    attribute(:gc_settings, kind_of: String, default:
    <<-CONFIG
        -XX:+UseParNewGC
        -XX:+UseConcMarkSweepGC
        -XX:CMSInitiatingOccupancyFraction=75
        -XX:+UseCMSInitiatingOccupancyOnly
        -XX:+HeapDumpOnOutOfMemoryError
      CONFIG
    )

    # these are the default settings for configuring elasticsearch.
    # if you override this, you must supply everything. 99% of the time,
    # you will not use this and will use the attribute below
    attribute(:default_configuration, kind_of: Hash, default: lazy { {
      # === NAMING
      'cluster.name' => 'elasticsearch',
      'node.name' => node.name,

      'path.conf' => path_conf,
      'path.data' => path_data,
      'path.logs' => path_logs,

      # === PRODUCTION SETTINGS
      'index.mapper.dynamic' => true,
      'action.auto_create_index' => true,
      'action.disable_delete_all_indices' => true,
      'node.max_local_storage_nodes' => 1,

      'discovery.zen.ping.multicast.enabled' => true,
      'discovery.zen.minimum_master_nodes' => 1,
      'gateway.type' => 'local',
      'gateway.expected_nodes' => 1,

      # === JMX SETTINGS
      'jmx.create_connector' => true,
      'jmx.port' => '9400-9500',
      'jmx.domain' => 'elasticsearch',

      # === PORT
      'http.port' => 9200,
    } })

    # these will be the main configuration settings, merged with any defaults
    # from the above :default_configuration. This allows you to supply specific
    # values without having to merge in the rest of the defaults above
    attribute(:configuration, kind_of: Hash, default: Hash.new)

  end
end
