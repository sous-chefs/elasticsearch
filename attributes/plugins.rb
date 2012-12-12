Chef::Log.debug "Attempting to load plugin list from the databag..."

plugins = Chef::DataBagItem.load('elasticsearch', 'plugins').to_hash['plugins'] rescue {}

Chef::Log.debug "Plugins list: #{plugins.keys.inspect}"

default.elasticsearch[:plugins] = plugins
default.elasticsearch[:plugins_mandatory] ||= []
