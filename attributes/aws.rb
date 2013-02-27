include_attribute 'elasticsearch::default'
include_attribute 'elasticsearch::plugins'

# Load configuration and credentials from data bag 'elasticsearch/aws' -
#
aws = Chef::DataBagItem.load('elasticsearch', 'aws') rescue {}
# ----------------------------------------------------------------------

default.elasticsearch[:plugins][:aws][:version] = '1.9.0'

# === AWS ===
# AWS configuration is set based on data bag values.
# You may choose to configure them in your node configuration instead.
#
default.elasticsearch[:gateway][:type]               = ( aws['gateway']['type']                rescue nil )
default.elasticsearch[:discovery][:type]             = ( aws['discovery']['type']              rescue nil )
default.elasticsearch[:gateway][:s3][:bucket]        = ( aws['gateway']['s3']['bucket']        rescue nil )

default.elasticsearch[:cloud][:ec2][:security_group] = ( aws['cloud']['ec2']['security_group'] rescue nil )
default.elasticsearch[:cloud][:aws][:access_key]     = ( aws['cloud']['aws']['access_key']     rescue nil )
default.elasticsearch[:cloud][:aws][:secret_key]     = ( aws['cloud']['aws']['secret_key']     rescue nil )
default.elasticsearch[:cloud][:aws][:region]         = ( aws['cloud']['aws']['region']         rescue nil )
default.elasticsearch[:cloud][:ec2][:endpoint]       = ( aws['cloud']['ec2']['endpoint']       rescue nil )

discovery_tags = ( aws['discovery']['ec2']['tag'] rescue [] )
discovery_tags.each do |tag_name, tag_value|
  default.elasticsearch[:discovery][:ec2][:tag][tag_name] = tag_value
end

default.elasticsearch[:cloud][:node][:auto_attributes] = true
