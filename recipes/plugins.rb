directory "#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/plugins/" do
  owner node.elasticsearch[:user]
  group node.elasticsearch[:user]
  mode 0755
  recursive true
end

node[:elasticsearch][:plugins].each do | name, config |
  if(name == "elasticsearch/elasticsearch-cloud-aws" and !node.recipe?("aws"))
        log "**** We are skipping this plugin : #{name}" do
            level :debug
        end
        next
    end
  install_plugin name, config
end
