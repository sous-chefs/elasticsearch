
class Chef
  class Resource::ElasticsearchPlugin < Chef::Resource::LWRPBase
    include ElasticsearchCookbook::Helpers
    resource_name :elasticsearch_plugin if respond_to?(:resource_name)
    actions(:install, :remove)
    default_action :install

    # You must override these for the package-installed version
    attribute(:plugin_dir, kind_of: String, default: "/usr/local/elasticsearch/plugins")
    attribute(:bindir, kind_of: String, default: "/usr/local/bin")

    attribute(:plugin_name, kind_of: String, :name_attribute => true)
    attribute(:version, kind_of: String)
    attribute(:url, kind_of: String)

    attribute(:user, kind_of: String, default: 'elasticsearch')
    attribute(:group, kind_of: String, default: 'elasticsearch')

  end
end
