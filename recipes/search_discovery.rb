node.set['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false
nodes = search_for_nodes(node['elasticsearch']['discovery']['search_query'],
                         node['elasticsearch']['discovery']['node_attribute'])
Chef::Log.debug("Found elasticsearch nodes at #{nodes.join(', ').inspect}")
node.set['elasticsearch']['discovery']['zen']['ping']['unicast']['hosts'] = nodes.join(',')
