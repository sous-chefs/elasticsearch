package "nginx"

user node[:nginx][:user] do
  comment "Nginx User"
  system true
  shell "/bin/false"
end

group node[:nginx][:user] do
  members node[:nginx][:user]
end

directory node[:nginx][:log_dir] do
  mode 0755
  recursive true
end

template "#{node[:nginx][:dir]}/nginx.conf" do
  mode 0644
  notifies :restart, 'service[nginx]'
end

if node.recipes.include?('monit') and respond_to?(:monitrc)
  monitrc "nginx.monitrc" do
    template_cookbook 'elasticsearch'
    source 'nginx.monitrc.conf.erb'
  end
end

service "nginx" do
  action [ :enable, :start ]
end
