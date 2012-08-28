# Create EBS for each device with defined size
#
node.elasticsearch[:data][:devices].
     select { |device, params| params[:ebs][:size] > 0 rescue nil }.
     each do |device, params|
       create_ebs device, params
end
