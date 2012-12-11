node.set[:elasticsearch][:plugins_mandatory]     |= ['cloud-aws']

install_plugin "elasticsearch/elasticsearch-cloud-aws/#{node.elasticsearch[:plugin][:aws][:version]}"
