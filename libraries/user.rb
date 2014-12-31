class Chef
  # Chef Resource for declaring a user and group for Elasticsearch
  class Resource::ElasticsearchUser < Resource
    include Poise

    actions(:create, :remove)

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

  # Chef Provider for creating a user and group for Elasticsearch
  class Provider::ElasticsearchUser < Provider
    include Poise

    def action_create
      converge_by("create elasticsearch_user resource #{new_resource.name}") do
        notifying_block do
          group new_resource.groupname do
            gid new_resource.gid
            action :create
            system true
          end

          user new_resource.username do
            comment new_resource.comment
            home    new_resource.homedir
            shell   new_resource.shell
            uid     new_resource.uid
            gid     new_resource.groupname
            supports manage_home: false
            action  :create
            system true
          end

          bash 'remove the elasticsearch user home' do
            user    'root'
            code    "rm -rf #{new_resource.homedir}"
            not_if  { ::File.symlink?("#{new_resource.homedir}") }
            only_if { ::File.directory?("#{new_resource.homedir}") }
          end
        end
      end
    end

    def action_remove
      converge_by("remove elasticsearch_user resource #{new_resource.name}") do
        notifying_block do
          # delete user before deleting the group
          user new_resource.username do
            action  :remove
          end

          group new_resource.groupname do
            action :remove
          end
        end
      end
    end
  end
end
