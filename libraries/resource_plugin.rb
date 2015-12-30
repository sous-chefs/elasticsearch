# Chef Resource for installing an elasticsearch plugin
class ElasticsearchCookbook::PluginResource < Chef::Resource::LWRPBase
  resource_name :elasticsearch_plugin
  provides :elasticsearch_plugin

  include ElasticsearchCookbook::Helpers

  actions(:install, :remove)
  default_action :install

  # if the name or url are different from the resource name
  attribute(:plugin_name, kind_of: String, name_attribute: true)
  attribute(:url, kind_of: String, name_attribute: true)
  attribute(:chef_proxy, kind_of: [TrueClass, FalseClass], default: true)

  # this is what helps the various resources find each other
  attribute(:instance_name, kind_of: String, default: nil)
end
