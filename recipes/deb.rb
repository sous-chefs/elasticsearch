include_recipe "elasticsearch::_default"
# See <http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/_linux.html>

filename = node.elasticsearch[:deb_url].split('/').last

service "elasticsearch" do
  supports :status => true, :restart => true, :stop => true
  action [ :nothing ]
end

if node.elasticsearch[:deb_type] == "source"   
  remote_file "#{Chef::Config[:file_cache_path]}/#{filename}" do
    source   node.elasticsearch[:deb_url]
    checksum node.elasticsearch[:deb_sha]
    mode 00644
  end

  dpkg_package "#{Chef::Config[:file_cache_path]}/#{filename}" do
    action :install
    notifies  :stop, "service[elasticsearch]" , :immediately
  end
else
  package "elasticsearch" do
    action :install
     options("--force-yes")
    notifies  :stop, "service[elasticsearch]" , :immediately	
  end
end

