include_recipe "elasticsearch::_default"
directory "#{node.elasticsearch[:dir]}/elasticsearch/plugins/" do
  owner node.elasticsearch[:user]
  group node.elasticsearch[:user]
  mode 0755
  recursive true
end

node[:elasticsearch][:plugins].each do | name, config |
  next if name == 'elasticsearch/elasticsearch-cloud-aws' && !node.recipe?('aws')
  plugname=/-(\w+)/.match(name)
  next if plugname != nil && !File.directory?("#{node.elasticsearch[:dir]}/elasticsearch/plugins/#{plugname[1]}")
  install_plugin name, config
end
