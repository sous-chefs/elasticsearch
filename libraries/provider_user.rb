
class Chef
  # Chef Provider for creating a user and group for Elasticsearch
  class Provider::ElasticsearchUser < Chef::Provider::LWRPBase

    action :create do
      converge_by("create elasticsearch_user resource #{new_resource.name}") do
        unless new_resource.homedir
          # if unset, default it to a calculated value
          new_resource.homedir ::File.join(new_resource.homedir_parent, new_resource.homedir_name)
        end

        group_r = group new_resource.groupname do
          gid new_resource.gid
          action :nothing
          system true
        end
        group_r.run_action(:create)
        new_resource.updated_by_last_action(true) if group_r.updated_by_last_action?

        user_r = user new_resource.username do
          comment new_resource.comment
          home    new_resource.homedir
          shell   new_resource.shell
          uid     new_resource.uid
          gid     new_resource.groupname
          supports manage_home: false
          action  :nothing
          system true
        end
        user_r.run_action(:create)
        new_resource.updated_by_last_action(true) if user_r.updated_by_last_action?
      end
    end

    action :remove do
      converge_by("remove elasticsearch_user resource #{new_resource.name}") do
        # delete user before deleting the group
        user_r = user new_resource.username do
          action  :nothing
        end
        user_r.run_action(:remove)
        new_resource.updated_by_last_action(true) if user_r.updated_by_last_action?

        group_r = group new_resource.groupname do
          action :nothing
        end
        group_r.run_action(:remove)
        new_resource.updated_by_last_action(true) if group_r.updated_by_last_action?
      end
    end
  end
end
