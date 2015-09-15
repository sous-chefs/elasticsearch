
class Chef

  # Chef Resource for configuring an Elasticsearch node
  #
  class Resource::ElasticsearchConfigure < Chef::Resource::LWRPBase
    resource_name :elasticsearch_configure if respond_to?(:resource_name)

    actions(:manage, :remove)
    default_action :manage

    # if you override one of these, you should probably override them all
    attribute(:dir, kind_of: String, default: "/usr/local") # creates /usr/local/elasticsearch
    attribute(:path_conf, kind_of: String, default: "/usr/local/etc/elasticsearch")
    attribute(:path_data, kind_of: String, default: "/usr/local/var/data/elasticsearch")
    attribute(:path_logs, kind_of: String, default: "/usr/local/var/log/elasticsearch")

    attribute(:user, kind_of: String, default: 'elasticsearch')
    attribute(:group, kind_of: String, default: 'elasticsearch')

    attribute(:template_elasticsearch_env, kind_of: String, default: 'elasticsearch.in.sh.erb')
    attribute(:template_elasticsearch_yml, kind_of: String, default: 'elasticsearch.yml.erb')
    attribute(:template_logging_yml, kind_of: String, default: 'logging.yml.erb')

    attribute(:logging, kind_of: Hash, default: {})

    attribute(:java_home, kind_of: String, default: nil)
    attribute(:es_home, kind_of: String, default: "/usr/local")

    # Calculations for this are done in the provider, as we can't do them in the
    # resource definition. default is 50% of RAM or 31GB, which ever is smaller.
    attribute(:allocated_memory, kind_of: String)

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
    attribute(:default_configuration, kind_of: Hash, default: {
      # === NAMING
      'cluster.name' => 'elasticsearch',
      # can't access node.name, so expect to have to set set this
      'node.name' => Chef::Config[:node_name],

      'path.conf' => "/usr/local/etc/elasticsearch",
      'path.data' => "/usr/local/var/data/elasticsearch",
      'path.logs' => "/usr/local/var/log/elasticsearch",

      'action.destructive_requires_name' => true,
      'node.max_local_storage_nodes' => 1,

      'discovery.zen.ping.multicast.enabled' => true,
      'discovery.zen.minimum_master_nodes' => 1,
      'gateway.expected_nodes' => 1,

      'http.port' => 9200,
    })

    # These settings are merged with the `default_configuration` attribute,
    # allowing you to override and set specific settings.
    #
    attribute(:configuration, kind_of: Hash, default: Hash.new)
  end
end
