module Extensions

  # Creates an EBS volume based on passed parameters and attaches it to the instance
  # via the [Fog](http://rubydoc.info/gems/fog/Fog/Compute/AWS/Volume) library.
  #
  # The credentials for accessing AWS API are loaded from `node.elasticsearch.cloud`.
  # Instead of using AWS access tokens, you can create the instance with a IAM role.
  #
  # You need to provide volume properties such as _size_ in the `params[:ebs]` hash.
  #
  # If `params[:snapshot_id]` is passed, the volume will be created from
  # the corresponding snapshot.
  #
  def create_ebs device, params={}

    ruby_block "Create EBS volume on #{device} (size: #{params[:ebs][:size]}GB)" do

      block do
        require 'fog'
        # get out region and instance_ID from the ohai node data - removes the reliance on open-uri and removes the possibility 
        # that we connect to the wrong region if the attribute is set wrong -TH
        region      = node[:ec2][:placement_availability_zone].chop()
        instance_id = node[:ec2][:instance_id]

        Chef::Log.debug("Region: #{region}, instance ID: #{instance_id}")

        # sets the options for the Fog connection to AWS -TH
        fog_options = { :provider => 'AWS', :region => region }
        # if access_key and secret_key are set, merge them in, otherwise fail back to using IAM role -TH
        if (access_key = node.elasticsearch[:cloud][:aws][:access_key]) &&
            (secret_key = node.elasticsearch[:cloud][:aws][:secret_key])
          fog_options.merge!(:aws_access_key_id => access_key, :aws_secret_access_key => secret_key)
        else  # Lack of credentials implies a IAM role will provide keys 
          fog_options.merge!(:use_iam_profile => true)
        end

        # build our AWS conenction ** be careful, this returns properly even if it fails to connect **
        # connection failures will result in "Excon::Errors::SocketError: getaddrinfo: Name or service not known (SocketError)" in the chef-client output
        # This will cause the run to fail. -TH
        aws = Fog::Compute.new(fog_options)

        # fetch the instance information from AWS -TH
        server = aws.servers.get(instance_id)
        
        # Create EBS volume if the device is free
        ebs_device = params[:ebs][:device] || device
        
		unless server.volumes.map(&:device).include?(ebs_device)
          options = { :device                => ebs_device,
                      :size                  => params[:ebs][:size],
                      :delete_on_termination => params[:ebs][:delete_on_termination],
                      :availability_zone     => node[:ec2][:placement_availability_zone], #use the node info to pick the AZ -TH
                      :server                => server }

          options[:type] = params[:ebs][:type] if params[:ebs][:type]
          options[:iops] = params[:ebs][:iops] if params[:ebs][:iops] and params[:ebs][:type] == "io1"

          if params[:ebs][:snapshot_id]
            if snapshot = aws.snapshots.get(params[:ebs][:snapshot_id])
              Chef::Log.info "Creating EBS from snapshot: #{snapshot.id} (" +
                             "Tags: #{snapshot.tags.inspect}, "             +
                             "Description: #{snapshot.description})"
              options[:snapshot_id] = snapshot.id
            else
              __message = "[!] Cannot find snapshot: #{params[:ebs][:snapshot_id]}"
              Chef::Log.fatal __message
              raise __message
            end
          end

          volume = aws.volumes.new(options)
          volume.save

          # Create tags
          aws.tags.new(:key => "Name", :value => node.name, :resource_id => volume.id, :resource_type => "volume").save
          aws.tags.new(:key => "ClusterName", :value => node.elasticsearch[:cluster][:name], :resource_id => volume.id, :resource_type => "volume").save

          # Checking if block device is attached
          Chef::Log.info("Attaching volume: #{volume.id} ")
          loop do
            `ls #{device} > /dev/null 2>&1`
            break if $?.success?
            print '.'
            sleep 1
          end

          Chef::Log.debug("Volume #{volume.id} is attached to #{instance_id} on #{device}")
        end

      end

    end

  end

end
