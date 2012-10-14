Chef::Log.debug "Attempting to loading plugin list from the databag..."

plugins = Chef::DataBagItem.load('elasticsearch', 'plugins').to_hash['plugins'] rescue {}

Chef::Log.debug "Loaded these plugins: #{plugins.keys}"

default.elasticsearch[:plugins] = plugins
default.elasticsearch[:plugins_mandatory] ||= []
