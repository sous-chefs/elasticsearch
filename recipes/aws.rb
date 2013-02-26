node.set[:elasticsearch][:plugin][:mandatory] = node[:elasticsearch][:plugin][:mandatory] | ['cloud-aws']

install_plugin "elasticsearch/elasticsearch-cloud-aws/#{node.elasticsearch[:plugins][:aws][:version]}"
