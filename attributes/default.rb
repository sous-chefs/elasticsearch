# Load settings from data bag 'elasticsearch/settings' -
#
settings = Chef::DataBagItem.load('elasticsearch', 'settings') rescue {}

# === VERSION ===
#
default.elasticsearch[:version]       = "0.19.8"
default.elasticsearch[:repository]    = "elasticsearch/elasticsearch"
default.elasticsearch[:filename]      = "elasticsearch-#{node.elasticsearch[:version]}.tar.gz"
default.elasticsearch[:download_url]  = "https://github.com/downloads/" +
                                        "#{node.elasticsearch[:repository]}/#{node.elasticsearch[:filename]}"

default.elasticsearch[:checksum]      = "6cc4c3a2439f48864050ba306c0e3569c064ad9097448b5452e11e3fc7c7d9e6"

# === INDEX ===
#
default.elasticsearch[:index_auto_create_index] = true
default.elasticsearch[:index_mapper_dynamic]    = true

# === PATHS ===
#
default.elasticsearch[:dir]       = "/usr/local"
default.elasticsearch[:user]      = "elasticsearch"
default.elasticsearch[:conf_path] = "/usr/local/etc/elasticsearch"
default.elasticsearch[:data_path] = "/usr/local/var/data/elasticsearch"
default.elasticsearch[:log_path]  = "/usr/local/var/log/elasticsearch"
default.elasticsearch[:pid_path]  = "/usr/local/var/run/elasticsearch"

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

# === SETTINGS ===
#
default.elasticsearch[:node_name]      = node.name
default.elasticsearch[:cluster_name]   = ( settings['cluster_name'] || "elasticsearch" rescue "elasticsearch" )
default.elasticsearch[:index_shards]   = "5"
default.elasticsearch[:index_replicas] = "1"

# === PERSISTENCE ===
#
default.elasticsearch[:gateway][:type] = nil

# === VARIA ===
#
default.elasticsearch[:disable_delete_all_indices] = true
default.elasticsearch[:thread_stack_size]  = "256k"
