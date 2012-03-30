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


  # Create ebs and attach to the instance
  #
  def create_ebs device, params={}
    # Install fog gem
    #
    git "/tmp/fog" do
      repository "https://github.com/fog/fog.git"
      revision "d1fbbe65b404e7d606f40070b7fc474bfa8ff406"
      action :sync
    end

    bash "build fog gem from git source" do
      code <<-EOS
        cd /tmp/fog && gem build fog.gemspec
      EOS

      not_if "ls -la /tmp/fog/fog-1.5.0.gem"
    end

    gem_package "install builded fog gem" do
      package_name "fog"
      source "/tmp/fog/fog-1.5.0.gem"
      action :install
    end

    ruby_block "Create EBS volume" do

      block do
        require 'fog'
        require 'open-uri'

        instance_id = open('http://169.254.169.254/latest/meta-data/instance-id'){|f| f.gets}
        region      = params[:region] || node.elasticsearch[:cloud][:aws][:region]
        Chef::Log.info("Instance region is #{region}")

        aws = Fog::Compute.new :provider =>              'AWS',
                               :region   =>              region,
                               :aws_access_key_id =>     node.elasticsearch[:cloud][:aws][:access_key],
                               :aws_secret_access_key => node.elasticsearch[:cloud][:aws][:secret_key]

        raise "Cannot find instance id!" unless instance_id
        Chef::Log.info("Instance ID is #{instance_id}")
        Chef::Log.info("Instance region is #{region}")
        server = aws.servers.get instance_id

        # Create EBS volume if device is free
        #
        unless server.volumes.map(&:device).include?(device)
          stop_elasticsearch = node.recipes.include?('monit') ? "sudo monit stop elasticsearch" : "sudo service elasticsearch stop"
          system stop_elasticsearch

          options = { :device                => device,
                      :size                  => params[:ebs][:size],
                      :delete_on_termination => params[:ebs][:delete_on_termination],
                      :availability_zone     => server.availability_zone,
                      :server                => server }

          options[:type] = params[:ebs][:type] if params[:ebs][:type]
          options[:iops] = params[:ebs][:iops] if params[:ebs][:iops] and params[:ebs][:type] == "io1"

          volume = aws.volumes.new options

          volume.save

          # Create tags
          tag = aws.tags.new :key => "Name", :value => node.name, :resource_id => volume.id, :resource_type => "volume"
          tag.save

          tag = aws.tags.new :key => "Cluster name", :value => node.elasticsearch[:cluster_name], :resource_id => volume.id, :resource_type => "volume"
          tag.save

          # Checking if block device is attached
          Chef::Log.info("Attaching volume #{volume.id}")
          loop do
            `ls #{device} > /dev/null 2>&1`
            break if $?.success?
            print '.'
            sleep 1
          end

          Chef::Log.info("Volume #{volume.id} is attached to #{instance_id}")
        end

      end

    end

  end


end
