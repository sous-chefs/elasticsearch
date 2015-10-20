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

      merged_configuration = es_conf.default_configuration.merge(es_conf.configuration)
      sanitized_node_name = merged_configuration['node.name'].to_s.gsub(/\W/, '_')
      pid_file = "#{es_conf.path_pid[es_install.type]}/#{sanitized_node_name}.pid"

      d_r = directory es_conf.path_pid[es_install.type] do
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
        variables(nofile_limit: new_resource.nofile_limit,
                  memlock_limit: new_resource.memlock_limit,
                  pid_file: pid_file,
                  path_conf: es_conf.path_conf[es_install.type],
                  user: es_user.username,
                  platform_family: node.platform_family,
                  bindir: es_conf.path_bin[es_install.type],
                  http_port: 9200, # TODO: does the init script really need this?
                  node_name: sanitized_node_name,
                  service_name: new_resource.service_name,
                  args: new_resource.args)
        action :nothing
      end
      init_r.run_action(:create)
      new_resource.updated_by_last_action(true) if init_r.updated_by_last_action?

      # Increase open file and memory limits
      #
      bash_r = bash 'enable user limits' do
        user 'root'

        code <<-END.gsub(/^              /, '')
          echo 'session    required   pam_limits.so' >> /etc/pam.d/su
        END

        not_if { ::File.read('/etc/pam.d/su').match(/^session    required   pam_limits\.so/) }
        action :nothing
      end
      bash_r.run_action(:run)
      new_resource.updated_by_last_action(true) if bash_r.updated_by_last_action?

      secf_r = file '/etc/security/limits.d/10-elasticsearch.conf' do
        content <<-END.gsub(/^          /, '')
          #{es_user.username} - nofile    #{new_resource.nofile_limit}
          #{es_user.username} - memlock   #{new_resource.memlock_limit}
        END
      end
      secf_r.run_action(:create)
      new_resource.updated_by_last_action(true) if secf_r.updated_by_last_action?

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
