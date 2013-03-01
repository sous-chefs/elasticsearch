Chef::Log.debug "Attempting to load plugin list from the databag..."

plugins = Chef::DataBagItem.load('elasticsearch', 'plugins')[node.chef_environment].to_hash['plugins'] rescue {}

Chef::Log.debug "Plugins list: #{plugins.keys.inspect}"

node.default.elasticsearch[:plugins] ||= plugins
node.default.elasticsearch[:plugin][:mandatory] = []
