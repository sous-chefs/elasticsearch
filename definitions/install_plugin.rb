# Install ElasticSearch plugin
#
# TODO: Make it a Chef LWRP [http://wiki.opscode.com/display/chef/Lightweight+Resources+and+Providers+(LWRP)]
# TODO: Install plugins based on node attribute, data bag values, etc
#
define :install_plugin do

  bash "/usr/local/bin/plugin -install #{params[:name]}" do
    user node.elasticsearch[:user]
    code "/usr/local/bin/plugin -install #{params[:name]}"

    notifies :restart, resources(:service => 'elasticsearch')

    not_if do
      Dir.entries("#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/plugins/").any? do |plugin|
        next if plugin =~ /^\./
        params[:name].include? plugin
      end rescue false
    end

  end
  
end
