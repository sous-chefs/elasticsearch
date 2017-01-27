# Chef Provider for configuring an elasticsearch service in the init system
class ElasticsearchCookbook::ServiceProvider < Chef::Provider::LWRPBase
  provides :elasticsearch_service
  include ElasticsearchCookbook::Helpers

  def whyrun_supported?
    true
  end

  use_inline_resources
  def action_remove
    raise "#{new_resource} remove not currently implemented"
  end

  def action_configure
    es_user = find_es_resource(Chef.run_context, :elasticsearch_user, new_resource)
    es_conf = find_es_resource(Chef.run_context, :elasticsearch_configure, new_resource)
    default_config_name = new_resource.service_name || new_resource.instance_name || es_conf.instance_name || 'elasticsearch'

    d_r = directory "#{es_conf.path_pid}-#{default_config_name}" do
      path es_conf.path_pid
      owner es_user.username
      group es_user.groupname
      mode '0755'
      recursive true
      action :create
    end

    # Create service for init and systemd
    #
    template "/etc/init.d/#{new_resource.service_name}" do
      source new_resource.init_source
      cookbook new_resource.init_cookbook
      owner 'root'
      mode '0755'
      variables(
        # we need to include something about #{progname} fixed in here.
        program_name: new_resource.service_name
      )
      only_if { ::File.exist?('/etc/init.d') }
      action :create
    end

    systemd_parent_r = directory "/usr/lib/systemd/system-#{default_config_name}" do
      path '/usr/lib/systemd/system'
      action :nothing
      only_if { ::File.exist?('/usr/lib/systemd') }
    end
    systemd_parent_r.run_action(:create)
    new_resource.updated_by_last_action(true) if systemd_parent_r.updated_by_last_action?

    default_conf_dir = node['platform_family'] == 'rhel' ? '/etc/sysconfig' : '/etc/default'
    systemd_r = template "/usr/lib/systemd/system/#{new_resource.service_name}.service" do
      source new_resource.systemd_source
      cookbook new_resource.systemd_cookbook
      owner 'root'
      mode '0644'
      variables(
        # we need to include something about #{progname} fixed in here.
        program_name: new_resource.service_name,
        default_dir: default_conf_dir,
        path_home: es_conf.path_home,
        es_user: es_user.username,
        es_group: es_user.groupname,
        nofile_limit: es_conf.nofile_limit
      )
      only_if 'which systemctl'
      action :nothing
    end
    systemd_r.run_action(:create)
    # special case here -- must reload unit files if we modified one
    if systemd_r.updated_by_last_action?
      new_resource.updated_by_last_action(true)

      reload_r = execute "reload-systemd-#{new_resource.service_name}" do
        command 'systemctl daemon-reload'
        action :nothing
        only_if 'which systemctl'
      end
      reload_r.run_action(:run)
    end

  end

  # Passthrough actions to service[service_name]
  #
  def action_enable
    passthrough_action(:enable)
  end

  def action_disable
    passthrough_action(:disable)
  end

  def action_start
    passthrough_action(:start)
  end

  def action_stop
    passthrough_action(:stop)
  end

  def action_restart
    passthrough_action(:restart)
  end

  def action_status
    passthrough_action(:status)
  end

  def passthrough_action(action)
    service "#{new_resource.service_name} #{action}" do
      service_name new_resource.service_name
      supports status: true, restart: true
      action action.to_sym
    end
  end
end
