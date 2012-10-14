set[:nginx][:dir]     = "/etc/nginx"
set[:nginx][:log_dir] = "/var/log/nginx"
set[:nginx][:user]    = "nginx"
set[:nginx][:binary]  = "/usr/sbin/nginx"
set[:nginx][:root]    = "/var/www/nginx"

default[:nginx][:keepalive]          = "on"
default[:nginx][:keepalive_timeout]  = 65
default[:nginx][:worker_processes]   = node.cpu[:total]
default[:nginx][:worker_connections] = 2048
