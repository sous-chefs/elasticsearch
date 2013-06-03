[Chef::Recipe, Chef::Resource].each { |l| l.send :include, ::Extensions }

value_for_platform_family(
  :debian => %w| build-essential libxslt1-dev libxml2-dev |,
  :rhel   => %w| gcc gcc-c++ make libxslt-devel libxml2-devel |
).each do |pkg| package pkg { action :nothing }.run_action(:upgrade) end

chef_gem 'fog' do
  version '1.10.1'
end

# Create EBS for each device with proper configuration
#
# See the `attributes/data` file for instructions.
#
node.elasticsearch[:data][:devices].each do |device, params|
  if params[:ebs] && !params[:ebs].keys.empty?
    create_ebs device, params
  end
end
