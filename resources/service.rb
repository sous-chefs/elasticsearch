unified_mode true

include ElasticsearchCookbook::Helpers

# this is what helps the various resources find each other
property :instance_name,
        String

property :service_name,
        String,
        name_property: true

property :args,
        String,
        default: '-d'

property :service_actions,
        [Symbol, String, Array],
        default: [:enable, :start]

property :init_source,
        String,
        default: 'initscript.erb'

property :init_cookbook,
        String,
        default: 'elasticsearch'

property :systemd_source,
        String,
        default: 'systemd_unit.erb'

property :systemd_cookbook,
        String,
        default: 'elasticsearch'

action :configure do
  es_user = find_es_resource(Chef.run_context, :elasticsearch_user, new_resource)
  es_install = find_es_resource(Chef.run_context, :elasticsearch_install, new_resource)
  es_conf = find_es_resource(Chef.run_context, :elasticsearch_configure, new_resource)
  default_config_name = new_resource.service_name || new_resource.instance_name || es_conf.instance_name || 'elasticsearch'

  d_r = directory "#{es_conf.path_pid}-#{default_config_name}" do
    path es_conf.path_pid
    owner es_user.username
    group es_user.groupname
    mode '0755'
    recursive true
    action :nothing
  end

  d_r.run_action(:create)

  new_resource.updated_by_last_action(true) if d_r.updated_by_last_action?

  # Create service for init and systemd
  #
  if new_resource.init_source
    init_r = template "/etc/init.d/#{new_resource.service_name}" do
      source new_resource.init_source
      cookbook new_resource.init_cookbook
      owner 'root'
      mode '0755'
      variables(
        # we need to include something about #{progname} fixed in here.
        program_name: new_resource.service_name,
        install_type: es_install.type
      )
      only_if { ::File.exist?('/etc/init.d') }
      action :nothing
    end

    init_r.run_action(:create)

    new_resource.updated_by_last_action(true) if init_r.updated_by_last_action?
  end

  if new_resource.systemd_source
    systemd_parent_r = directory "/usr/lib/systemd/system-#{default_config_name}" do
      path '/usr/lib/systemd/system'
      action :nothing
      only_if { ::File.exist?('/usr/lib/systemd') }
    end

    systemd_parent_r.run_action(:create)

    new_resource.updated_by_last_action(true) if systemd_parent_r.updated_by_last_action?

    default_conf_dir = platform_family?('rhel', 'amazon') ? '/etc/sysconfig' : '/etc/default'

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
        nofile_limit: es_conf.nofile_limit,
        install_type: es_install.type,
        version: es_install.version
      )
      only_if 'which systemctl'
      action :nothing
    end

    systemd_r.run_action(:create)

    # special case here -- must reload unit files if we modified one
    if systemd_r.updated_by_last_action?
      new_resource.updated_by_last_action(systemd_r.updated_by_last_action?)

      reload_r = execute "reload-systemd-#{new_resource.service_name}" do
        command 'systemctl daemon-reload'
        action :nothing
        only_if 'which systemctl'
      end
      reload_r.run_action(:run)
    end
  end

  # flatten in an array here, in case the service_actions are a symbol vs. array
  [new_resource.service_actions].flatten.each do |act|
    passthrough_action(act)
  end
end

# Passthrough actions to service[service_name]
#
action :enable do
  passthrough_action(:enable)
end

action :disable do
  passthrough_action(:disable)
end

action :start do
  passthrough_action(:start)
end

action :stop do
  passthrough_action(:stop)
end

action :restart do
  passthrough_action(:restart)
end

action :status do
  passthrough_action(:status)
end

action_class do
  def passthrough_action(action)
    svc_r = lookup_service_resource
    svc_r.run_action(action)
    new_resource.updated_by_last_action(true) if svc_r.updated_by_last_action?
  end

  def lookup_service_resource
    rc = Chef.run_context.resource_collection
    rc.find("service[#{new_resource.service_name}]")
  rescue
    service new_resource.service_name do
      supports status: true, restart: true
      action :nothing
    end
  end
end
