# Chef Provider for configuring an elasticsearch service in the init system
class ElasticsearchCookbook::ServiceProvider < Chef::Provider::LWRPBase

  provides :elasticsearch_service
  include ElasticsearchCookbook::Helpers

  action :remove do
    fail "#{new_resource} remove not currently implemented"
  end

  action :configure do
    converge_by('configure elasticsearch service') do
      es_user = find_es_resource(run_context, :elasticsearch_user, new_resource)
      es_install = find_es_resource(run_context, :elasticsearch_install, new_resource)
      es_conf = find_es_resource(run_context, :elasticsearch_configure, new_resource)

      d_r = directory es_conf.path_pid[es_install.type] do
        owner es_user.username
        group es_user.groupname
        mode '0755'
        recursive true
        action :nothing
      end
      d_r.run_action(:create)
      new_resource.updated_by_last_action(true) if d_r.updated_by_last_action?

      # Create service
      #
      init_r = template "/etc/init.d/#{new_resource.service_name}" do
        source new_resource.init_source
        cookbook new_resource.init_cookbook
        owner 'root'
        mode 0755
        variables(
          # we need to include something about #{progname} fixed in here.
          program_name: new_resource.service_name
        )
        action :nothing
      end
      init_r.run_action(:create)
      new_resource.updated_by_last_action(true) if init_r.updated_by_last_action?

      svc_r = service new_resource.service_name do
        supports :status => true, :restart => true
        action :nothing
      end
      new_resource.service_actions.each do |act|
        svc_r.run_action(act)
        new_resource.updated_by_last_action(true) if svc_r.updated_by_last_action?
      end
    end
  end
end
