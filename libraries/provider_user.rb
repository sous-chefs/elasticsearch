# Chef Provider for creating a user and group for Elasticsearch
class ElasticsearchCookbook::UserProvider < Chef::Provider::LWRPBase
  include ElasticsearchCookbook::Helpers

  provides :elasticsearch_user

  use_inline_resources if defined?(use_inline_resources)

  def whyrun_supported?
    false
  end

  action :create do
    group_r = group new_resource.groupname do
      gid new_resource.gid
      action :nothing
      system true
    end
    group_r.run_action(:create)
    new_resource.updated_by_last_action(true) if group_r.updated_by_last_action?

    user_r = user new_resource.username do
      comment new_resource.comment
      shell   new_resource.shell
      uid     new_resource.uid
      gid     new_resource.groupname
      supports(manage_home: false)
      action :nothing
      system true
    end
    user_r.run_action(:create)
    new_resource.updated_by_last_action(true) if user_r.updated_by_last_action?
  end

  action :remove do
    # delete user before deleting the group
    user_r = user new_resource.username do
      action :nothing
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
