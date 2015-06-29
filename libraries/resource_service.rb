require 'poise'

class Chef
  # Chef Resource for declaring a service for Elasticsearch
  class Resource::ElasticsearchService < Resource
    include Poise

    actions(:configure, :remove)
    default_action :configure

    attribute(:service_name, kind_of: String, :name_attribute => true)
    attribute(:node_name, kind_of: String, default: lazy { node.name } )
    attribute(:path_conf, kind_of: String, default: "/usr/local/etc/elasticsearch")
    attribute(:bindir, kind_of: String, default: "/usr/local/bin")
    attribute(:args, kind_of: String, default: '-d')

    attribute(:pid_path, kind_of: String, default: "/usr/local/var/run")
    attribute(:pid_file, kind_of: String,
      default: lazy { "#{pid_path}/#{node_name.to_s.gsub(/\W/, '_')}.pid" })

    attribute(:user, kind_of: String, default: lazy { name }) # default to resource name
    attribute(:group, kind_of: String, default: lazy { user }) # default to username

    # default user limits
    attribute(:memlock_limit, kind_of: String, default: 'unlimited')
    attribute(:nofile_limit, kind_of: String, default: '64000')
  end
end
