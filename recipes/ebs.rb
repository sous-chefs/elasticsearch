[Chef::Recipe, Chef::Resource].each { |l| l.send :include, ::Extensions }

# Install the Fog gem for Chef
#
# NOTE: The `chef_gem` resource is run *before* all other recipes,
#       during node compile phase, so you have to have development packages
#       and the libxml bindings installed for Nokogiri (a dependency of Fog).
#
#       Add a line like this to your bootstrap template, AWS user data, etc.:
#
#       yum install gcc gcc-c++ make automake install ruby-devel libxml2-devel libxslt-devel -y
#
chef_gem("fog") { action :install }

# Create EBS for each device with proper configuration
#
# See the `attributes/data` file for instructions.
#
node.elasticsearch[:data][:devices].
  reject do |device, params|
    params[:ebs].nil? || params[:ebs].keys.empty?
  end.
  each do |device, params|
    create_ebs device, params
  end
