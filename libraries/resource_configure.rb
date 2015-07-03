require 'poise'

class Chef

  # Chef Resource for configuring an Elasticsearch node
  #
  class Resource::ElasticsearchConfigure < Resource
    include Poise

    actions(:manage, :remove)
    default_action :manage

    attribute(:dir, kind_of: String, default: "/usr/local")

    attribute(:path_conf, kind_of: String, default: lazy { "#{dir}/etc/elasticsearch" })
    attribute(:path_data, kind_of: String, default: lazy { "#{dir}/var/data/elasticsearch" })
    attribute(:path_logs, kind_of: String, default: lazy { "#{dir}/var/log/elasticsearch" })

    attribute(:user, kind_of: String, default: 'elasticsearch')
    attribute(:group, kind_of: String, default: 'elasticsearch')

    attribute(:template_elasticsearch_env, kind_of: String, default: 'elasticsearch.in.sh.erb')
    attribute(:template_elasticsearch_yml, kind_of: String, default: 'elasticsearch.yml.erb')
    attribute(:template_logging_yml, kind_of: String, default: 'logging.yml.erb')

    attribute(:logging, kind_of: Hash, default: {})

    attribute(:java_home, kind_of: String, default: nil)
    attribute(:es_home, kind_of: String, default: lazy { dir })

    attribute(:allocated_memory, kind_of: String, default: lazy { compute_allocated_memory } )
    attribute(:thread_stack_size, kind_of: String, default: "256k")
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

    # These are the default settings. Most of the time, you want to override the `configuration` attribute below.
    #
    attribute(:default_configuration, kind_of: Hash, default: lazy { {
      # === NAMING
      'cluster.name' => 'elasticsearch',
      'node.name' => node.name,

      'path.conf' => path_conf,
      'path.data' => path_data,
      'path.logs' => path_logs,

      'action.destructive_requires_name' => true,
      'node.max_local_storage_nodes' => 1,

      'discovery.zen.ping.multicast.enabled' => true,
      'discovery.zen.minimum_master_nodes' => 1,
      'gateway.expected_nodes' => 1,

      'http.port' => 9200,
    } })

    # These settings are merged with the `default_configuration` attribute,
    # allowing you to override and set specific settings.
    #
    attribute(:configuration, kind_of: Hash, default: Hash.new)

    def compute_allocated_memory
      half = (node.memory.total.to_i * 0.5 ).floor / 1024
      half > 31000 ? "31g" : "#{half}m"
    end
  end
end
