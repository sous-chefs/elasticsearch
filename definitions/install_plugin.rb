# Install ElasticSearch plugin
#
define :install_plugin do

  bash "/usr/local/bin/plugin -install #{params[:name]}" do
    user "root"
    code "/usr/local/bin/plugin -install #{params[:name]}"

    notifies :restart, resources(:service => 'elasticsearch')

    not_if do
      Dir.entries("#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/plugins/").any? do |plugin|
        params[:name].include? plugin
      end rescue false
    end

  end
  
end
