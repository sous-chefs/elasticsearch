# Try to load data bag item 'elasticsearch/aws' ------------------
#
users = Chef::DataBagItem.load('elasticsearch', 'users')['users'] rescue []
# ----------------------------------------------------------------

# === NGINX ===
# Allowed users are set based on data bag values.
# You may choose to configure them in your node configuration instead.
#
default.elasticsearch[:nginx][:port]           = "8080"
default.elasticsearch[:nginx][:dir]            = "/etc/nginx"
default.elasticsearch[:nginx][:user]           = "nginx"
default.elasticsearch[:nginx][:log_dir]        = "/var/log/nginx"
default.elasticsearch[:nginx][:users]          = users
default.elasticsearch[:nginx][:passwords_file] = "#{node.elasticsearch[:conf_path]}/passwords"
