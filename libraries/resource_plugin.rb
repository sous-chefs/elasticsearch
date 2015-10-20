# Chef Resource for installing an elasticsearch plugin
class ElasticsearchCookbook::PluginResource < Chef::Resource::LWRPBase
  resource_name :elasticsearch_plugin
  provides :elasticsearch_plugin

  include ElasticsearchCookbook::Helpers

  actions(:install, :remove)
  default_action :install

  # this is what helps the various resources find each other
  attribute(:instance_name, kind_of: String, default: nil)

  attribute(:plugin_name, kind_of: String, name_attribute: true)
  attribute(:version, kind_of: String)
  attribute(:url, kind_of: String)
end
