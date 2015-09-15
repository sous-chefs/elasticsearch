
class Chef
  # Chef Resource for declaring a user and group for Elasticsearch
  class Resource::ElasticsearchUser < Chef::Resource::LWRPBase
    resource_name :elasticsearch_user if respond_to?(:resource_name)
    actions(:create, :remove)
    default_action :create

    attribute(:username, kind_of: String, name_attribute: true) # default to resource name
    attribute(:uid, kind_of: Integer)
    attribute(:shell, kind_of: String, default: '/bin/bash')
    attribute(:comment, kind_of: String, default: 'Elasticsearch User')

    attribute(:homedir_name, kind_of: String, name_attribute: true) # default to resource name
    attribute(:homedir_parent, kind_of: String, default: '/usr/local') # windows requires override
    attribute(:homedir, kind_of: String, default: nil) # defaults to ::File.join(homedir_parent, homedir_name)

    attribute(:groupname, kind_of: String, name_attribute: true) # default to resource name
    attribute(:gid, kind_of: Integer)
  end
end
