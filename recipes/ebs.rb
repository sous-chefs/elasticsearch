[Chef::Recipe, Chef::Resource].each { |l| l.send :include, ::Extensions }

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
