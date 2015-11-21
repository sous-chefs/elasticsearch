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

  attribute(:service_name, kind_of: String, name_attribute: true)
  attribute(:args, kind_of: String, default: '-d')

  # service actions
  attribute(:service_actions, kind_of: [Symbol, Array], default: [:enable])

  # allow overridable init script
  attribute(:init_source, kind_of: String, default: 'initscript.erb')
  attribute(:init_cookbook, kind_of: String, default: 'elasticsearch')
end
