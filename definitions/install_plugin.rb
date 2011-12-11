# Install ElasticSearch plugin
#
define :install_plugin do

  bash "/usr/local/bin/plugin -install #{params[:name]}" do
    user "root"
    code "/usr/local/bin/plugin -install #{params[:name]}"

    notifies :restart, resources(:service => 'elasticsearch')

    not_if "test -d #{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/plugins/#{params[:name]}"
  end
  
end
