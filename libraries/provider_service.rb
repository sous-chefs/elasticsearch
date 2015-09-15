
class Chef
  # Chef Provider for configuring an elasticsearch service in the init system
  class Provider::ElasticsearchService < Chef::Provider::LWRPBase
    action :remove do
      raise "#{new_resource} remove not currently implemented"
    end

    action :configure do
      converge_by('configure elasticsearch service') do
        d_r = directory new_resource.pid_path do
          mode '0755'
          recursive true
          action :nothing
        end
        d_r.run_action(:create)
        new_resource.updated_by_last_action(true) if d_r.updated_by_last_action?

        # Create service
        #
        init_r = template "/etc/init.d/#{new_resource.service_name}" do
          source "elasticsearch.init.erb"
          cookbook 'elasticsearch'
          owner 'root'
          mode 0755
          variables({
            nofile_limit: new_resource.nofile_limit,
            memlock_limit: new_resource.memlock_limit,
            pid_file: new_resource.pid_file,
            path_conf: new_resource.path_conf,
            user: new_resource.user,
            platform_family: node.platform_family,
            bindir: new_resource.bindir,
            http_port: 9200, # TODO: does the init script really need this?
            node_name: new_resource.node_name,
            service_name: new_resource.service_name,
            args: new_resource.args
            })
          action :nothing
        end
        init_r.run_action(:create)
        new_resource.updated_by_last_action(true) if init_r.updated_by_last_action?

        # Increase open file and memory limits
        #
        bash_r = bash "enable user limits" do
          user 'root'

          code <<-END.gsub(/^              /, '')
            echo 'session    required   pam_limits.so' >> /etc/pam.d/su
          END

          not_if { ::File.read("/etc/pam.d/su").match(/^session    required   pam_limits\.so/) }
          action :nothing
        end
        bash_r.run_action(:run)
        new_resource.updated_by_last_action(true) if bash_r.updated_by_last_action?

        secf_r = file "/etc/security/limits.d/10-elasticsearch.conf" do
          content <<-END.gsub(/^          /, '')
            #{new_resource.user} - nofile    #{new_resource.nofile_limit}
            #{new_resource.user} - memlock   #{new_resource.memlock_limit}
          END
        end
        secf_r.run_action(:create)
        new_resource.updated_by_last_action(true) if secf_r.updated_by_last_action?

        svc_r = service new_resource.service_name do
          supports :status => true, :restart => true
          action :nothing
        end
        svc_r.run_action(:enable)
        new_resource.updated_by_last_action(true) if svc_r.updated_by_last_action?
      end
    end
  end
end
