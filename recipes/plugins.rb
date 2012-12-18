node[:elasticsearch][:plugins].each do | name, config |
  install_plugin name, config
end

directory "#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/plugins/" do
  owner node.elasticsearch[:user]
  group node.elasticsearch[:user]
  mode 0755
  recursive true
end
