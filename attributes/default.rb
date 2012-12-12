# Load settings from data bag 'elasticsearch/settings' -
#
settings = Chef::DataBagItem.load('elasticsearch', 'settings') rescue {}

# === VERSION ===
#
default.elasticsearch[:version]       = "0.20.1"
default.elasticsearch[:host]          = "http://download.elasticsearch.org"
default.elasticsearch[:repository]    = "elasticsearch/elasticsearch"
default.elasticsearch[:filename]      = "elasticsearch-#{node.elasticsearch[:version]}.tar.gz"
default.elasticsearch[:download_url]  = [node.elasticsearch[:host], node.elasticsearch[:repository], node.elasticsearch[:filename]].join('/')

# === SETTINGS ===
#
default.elasticsearch[:node_name]      = node.name
default.elasticsearch[:cluster_name]   = ( settings['cluster_name'] || "elasticsearch" rescue "elasticsearch" )
default.elasticsearch[:index_shards]   = "5"
default.elasticsearch[:index_replicas] = "1"

# === USER & PATHS
#
default.elasticsearch[:dir]       = "/usr/local"
default.elasticsearch[:user]      = "elasticsearch"
default.elasticsearch[:conf_path] = "/usr/local/etc/elasticsearch"
default.elasticsearch[:data_path] = "/usr/local/var/data/elasticsearch"
default.elasticsearch[:log_path]  = "/usr/local/var/log/elasticsearch"
default.elasticsearch[:pid_path]  = "/usr/local/var/run/elasticsearch"
default.elasticsearch[:pid_file]  = "#{node.elasticsearch[:pid_path]}/#{node.elasticsearch[:node_name].to_s.gsub(/\W/, '_')}.pid"

# === MEMORY ===
#
# Maximum amount of memory to use is automatically computed as a bit over 1/2 of total available memory on the machine.
# You may choose to set it in your node/role configuration instead.
# By default, the `mlockall` is set to true: on weak machines and Vagrant boxes, you may want to disable it.
#
allocated_memory = "#{(node.memory.total.to_i * 0.6 ).floor / 1024}m"
default.elasticsearch[:allocated_memory] = allocated_memory
default.elasticsearch[:mlockall] = true

# === LIMITS ===
#
default.elasticsearch[:limits]  = {}
default.elasticsearch[:limits][:memlock] = 'unlimited'
default.elasticsearch[:limits][:nofile]  = '64000'

# === PERSISTENCE ===
#
default.elasticsearch[:gateway][:type] = nil

# === VARIA ===
#
default.elasticsearch[:index_auto_create_index] = true
default.elasticsearch[:index_mapper_dynamic]    = true
default.elasticsearch[:disable_delete_all_indices] = true
default.elasticsearch[:thread_stack_size]       = "256k"

# === NETWORK ===
#
default.elasticsearch[:network] = {}
default.elasticsearch[:transport] = {}
default.elasticsearch[:http] = {}

# === DISCOVERY ===
#
default.elasticsearch[:discovery][:multicast] = "false"

# === LOGGING ===
#
default.elasticsearch[:slowlog_threshold_query] = {}
default.elasticsearch[:slowlog_threshold_fetch] = {}
default.elasticsearch[:slowlog_threshold_index] = {}
default.elasticsearch[:gclog_PorNew] = {}
default.elasticsearch[:gclog_ConcurrentMarkSweep] = {}

# === Recovery ===
#
default.elasticsearch[:recovery] = {}

