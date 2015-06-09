require 'poise'

class Chef
  # Chef Provider for configuring an elasticsearch service in the init system
  class Provider::ElasticsearchService < Provider
    include Poise

    def action_remove
    end

    def action_configure
      directory new_resource.pid_path do
        mode '0755'
        recursive true
      end

      # Create service
      #
      template "/etc/init.d/#{new_resource.service_name}" do
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
      end

      # Increase open file and memory limits
      #
      bash "enable user limits" do
        user 'root'

        code <<-END.gsub(/^              /, '')
          echo 'session    required   pam_limits.so' >> /etc/pam.d/su
        END

        not_if { ::File.read("/etc/pam.d/su").match(/^session    required   pam_limits\.so/) }
      end

      file "/etc/security/limits.d/10-elasticsearch.conf" do
        content <<-END.gsub(/^          /, '')
          #{new_resource.user} - nofile    #{new_resource.nofile_limit}
          #{new_resource.user} - memlock   #{new_resource.memlock_limit}
        END
        notifies :write, 'log[increase limits]', :immediately
      end

      log "increase limits" do
        message "increased limits for the #{new_resource.user} user"
        action :nothing
      end

      service new_resource.service_name do
        supports :status => true, :restart => true
        action [ :enable ]
      end
    end
  end
end
