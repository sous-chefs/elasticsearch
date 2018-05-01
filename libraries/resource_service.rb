# Chef Resource for declaring a service for Elasticsearch
class ElasticsearchCookbook::ServiceResource < Chef::Resource::LWRPBase
  resource_name :elasticsearch_service
  provides :elasticsearch_service

  actions(
    :configure, :remove, # our custom actions
    :enable, :disable, :start, :stop, :restart, :status # passthrough to service resource
  )
  default_action :configure

  # this is what helps the various resources find each other
  attribute(:instance_name, kind_of: String, default: nil)
  attribute(:path_conf,    kind_of: String, default: '/etc/elasticsearch')
  attribute(:path_data,    kind_of: String, default: '/var/lib/elasticsearch')
  attribute(:path_logs,    kind_of: String, default: '/var/log/elasticsearch')

  attribute(:service_name, kind_of: String, name_attribute: true)
  attribute(:args, kind_of: String, default: '-d')

  # service actions
  attribute(:service_actions, kind_of: [Symbol, String, Array], default: [:enable, :start].freeze)

  attribute(:startup_method, kind_of: String, default: 'init')

  # allow overridable init script
  attribute(:initd_source, kind_of: String, default: 'initdscript.erb')
  attribute(:initd_cookbook, kind_of: String, default: 'elasticsearch')

  # allow overridable upstart script
  attribute(:init_source, kind_of: String, default: 'initscript.erb')
  attribute(:init_cookbook, kind_of: String, default: 'elasticsearch')

  # allow overridable systemd unit
  attribute(:systemd_source, kind_of: String, default: 'systemd_unit.erb')
  attribute(:systemd_cookbook, kind_of: String, default: 'elasticsearch')

  # allow overridable startup_timeout for ubuntu/debian initscript templates
  attribute(:startup_timeout, kind_of: String, default: '10')
end
