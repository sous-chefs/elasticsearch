node.default[:elasticsearch][:plugin][:mandatory] = Array(node[:elasticsearch][:plugin][:mandatory] | ['kopf'])

install_plugin "lmenezes/elasticsearch-kopf/#{node.elasticsearch['plugins']['lmenezes/elasticsearch-kopf']['version']}"
