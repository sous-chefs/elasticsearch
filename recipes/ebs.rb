[Chef::Recipe, Chef::Resource].each { |l| l.send :include, ::Extensions }

# Install the Fog gem for Chef
#

fog_pkgs = value_for_platform(
  "default" => ["libxslt1-dev","libxml2-dev"]
)

fog_pkgs.each do |pkg|
  p =  package pkg do
    action :nothing
  end
  p.run_action(:upgrade)
end

chef_gem("fog") { action :install }

# Create EBS for each device with proper configuration
#
# See the `attributes/data` file for instructions.
#
node.elasticsearch[:data][:devices].each do |device, params|
  if params[:ebs] && !params[:ebs].keys.empty?
    create_ebs device, params
  end
end
