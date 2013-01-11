module Extensions

  # Install elasticsearch plugin
  #
  # In the simplest form, just pass a plugin name in the GitHub <user>/<repo> format:
  #
  #     install_plugin 'karmi/elasticsearch-paramedic'
  #
  # You may also optionally pass a version:
  #
  #     install_plugin 'lukas-vlcek/bigdesk', 'version' => '1.0.0'
  #
  # ... as well as the URL:
  #
  #     install_plugin 'hunspell', 'url' => 'https://github.com/downloads/.../elasticsearch-analysis-hunspell-1.1.1.zip'
  #
  # In the provisioning process, you won't be calling this method directly -- you'll configure
  # plugin names correctly in the role/node attributes or in the data bag.
  #
  # Example:
  #
  #     { elasticsearch: {
  #         plugins: {
  #           'karmi/elasticsearch-paramedic' => {},
  #           'lukas-vlcek/bigdesk'           => { 'version' => '1.0.0' },
  #           'hunspell'                      => { 'url' => 'https://github.com/downloads/...' }
  #         }
  #       }
  #     }
  #
  # See <http://wiki.opscode.com/display/chef/Setting+Attributes+(Examples)> for more info.
  #
  def install_plugin name, params={}

    ruby_block "Install plugin: #{name}" do
      block do
        version = params['version'] ? "/#{params['version']}" : nil
        url     = params['url']     ? " -url #{params['url']}" : nil

        command = "/usr/local/bin/plugin -install #{name}#{version}#{url}"
        Chef::Log.debug command

        system command

        # Ensure proper permissions
        system "chown -R #{node.elasticsearch[:user]}:#{node.elasticsearch[:user]} #{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/plugins/"
      end

      notifies :restart, resources(:service => 'elasticsearch')

      not_if do
        Dir.entries("#{node.elasticsearch[:dir]}/elasticsearch-#{node.elasticsearch[:version]}/plugins/").any? do |plugin|
          next if plugin =~ /^\./
          name.include? plugin
        end rescue false
      end

    end

  end

end
