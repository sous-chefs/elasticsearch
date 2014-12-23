node.default[:elasticsearch][:plugin][:mandatory] = Array(node[:elasticsearch][:plugin][:mandatory] | ['kopf'])

install_plugin "lmenezes/elasticsearch-kopf/#{node.elasticsearch['plugins']['kopf']['version']}"
