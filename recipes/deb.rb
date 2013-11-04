# See <http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/_linux.html>

filename = node.elasticsearch[:deb_url].split('/').last

remote_file "#{Chef::Config[:file_cache_path]}/#{filename}" do
  source   node.elasticsearch[:deb_url]
  checksum node.elasticsearch[:deb_sha]
  mode 00644
end

dpkg_package "#{Chef::Config[:file_cache_path]}/#{filename}" do
  action :install
end
