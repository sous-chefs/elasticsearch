# This recipe configures the cluster to use Chef search for discovering Elasticsearch nodes.
# This allows the cluster to operate without multicast, without AWS, and without having to manually manage nodes.
#
# By default it will search for other nodes with the query
# `role:elasticsearch AND chef_environment:#{node.chef_environment}`, but you may override that with the
# `node['elasticsearch']['discovery']['search_query']` attribute.
#
# Reasonable values include
# `"tag:elasticsearch AND chef_environment:#{node.chef_environment}"` and
# `"(role:es-server OR role:es-client) AND chef_environment:#{node.chef_environment}"`.
#
# By default it will attempt to select a reasonable IP address for each
# node, using `node['cloud']['local_ipv4']` on cloud servers, and
# `node['ipaddress']` elsewhere.
#
# You may override that with the
# `node'elasticsearch']['discovery']['node_attribute']` attribute.
# Reasonable values include `"fqdn"` and `"cloud.public_ipv4`.
#
node.set['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false
nodes = search_for_nodes(node['elasticsearch']['discovery']['search_query'],
                         node['elasticsearch']['discovery']['node_attribute'])
Chef::Log.debug("Found elasticsearch nodes at #{nodes.join(', ').inspect}")
node.set['elasticsearch']['discovery']['zen']['ping']['unicast']['hosts'] = nodes.join(',')
