# Try to load data bag item 'elasticsearch/aws' ------------------
#
users = Chef::DataBagItem.load('elasticsearch', 'users')['users'] rescue []
# ----------------------------------------------------------------

# === NGINX ===
# Allowed users are set based on data bag values.
# You may choose to configure them in your node configuration instead.
#
default.elasticsearch[:nginx][:port]           = "8080"
default.elasticsearch[:nginx][:dir]            = ( node.nginx[:dir]     rescue '/etc/nginx'     )
default.elasticsearch[:nginx][:user]           = ( node.nginx[:user]    rescue 'nginx'          )
default.elasticsearch[:nginx][:log_dir]        = ( node.nginx[:log_dir] rescue '/var/log/nginx' )
default.elasticsearch[:nginx][:users]          = users
default.elasticsearch[:nginx][:passwords_file] = "#{node.elasticsearch[:conf_path]}/passwords"
