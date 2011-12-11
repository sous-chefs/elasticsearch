# === NGINX ===

default.elasticsearch[:nginx][:port]           = "8080"
default.elasticsearch[:nginx][:dir]            = "/etc/nginx"
default.elasticsearch[:nginx][:user]           = "nginx"
default.elasticsearch[:nginx][:log_dir]        = "/var/log/nginx"
default.elasticsearch[:nginx][:passwords_file] = "#{node.elasticsearch[:conf_path]}/passwords"
