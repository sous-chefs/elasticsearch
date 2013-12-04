node.default.elasticsearch[:plugin][:mandatory] = []

Chef::Log.debug "Plugins list: #{default.elasticsearch.plugins.inspect}"
