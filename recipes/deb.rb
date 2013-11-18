include_recipe "elasticsearch::_default"

filename = node.elasticsearch[:deb_url].split('/').last
   
remote_file "#{Chef::Config[:file_cache_path]}/#{filename}" do
  source   node.elasticsearch[:deb_url]
  checksum node.elasticsearch[:deb_sha]
  mode 00644
end

service "elasticsearch" do
  supports :status => true, :restart => true, :stop => true
  action [ :nothing ]
end

dpkg_package "#{Chef::Config[:file_cache_path]}/#{filename}" do
  action :install
  notifies  :stop, "service[elasticsearch]" , :immediately
end


#use bash to stop service started automatically during the package installation
# a notify to service['elasticsearch'] do it too late
#bash "stop-service" do
#  user "root"
#  cwd "/tmp"
#  code <<-EOH
#  /etc/init.d/elasticsearch stop
#  EOH
#end
