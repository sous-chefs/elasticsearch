require 'poise'

class Chef
  # Chef Resource for declaring a user and group for Elasticsearch
  class Resource::ElasticsearchUser < Resource
    include Poise

    actions(:create, :remove)
    default_action :create

    attribute(:username, kind_of: String, default: lazy { name }) # default to resource name
    attribute(:uid, kind_of: Integer)
    attribute(:shell, kind_of: String, default: '/bin/bash')
    attribute(:comment, kind_of: String, default: 'Elasticsearch User')

    attribute(:homedir_name, kind_of: String, default: lazy { username }) # default to username
    attribute(:homedir_parent, kind_of: String, default: '/usr/local') # windows requires override
    attribute(:homedir, kind_of: String, default: lazy { ::File.join(homedir_parent, homedir_name) }) # combination of next two

    attribute(:groupname, kind_of: String, default: lazy { username }) # default to username
    attribute(:gid, kind_of: Integer)
  end
end
