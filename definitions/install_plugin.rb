# Install ElasticSearch plugin
#
define :install_plugin do

  ruby_block "Install plugin: #{params[:name]}" do
    block do
      Chef::Log.info "Installing elasticsearch plugin: #{params[:name]}"

      command = "/usr/local/bin/plugin -install #{params[:name]}"
      Chef::Log.debug command

      system command
    end

    notifies :restart, resources(:service => 'elasticsearch')

    not_if do
      Dir.entries("#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/plugins/").any? do |plugin|
        next if plugin =~ /^\./
        params[:name].include? plugin
      end rescue false
    end

  end

end
