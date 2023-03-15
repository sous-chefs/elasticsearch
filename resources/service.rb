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
  es_conf = find_es_resource(Chef.run_context, :elasticsearch_configure, new_resource)
  default_config_name = new_resource.service_name || new_resource.instance_name || es_conf.instance_name || 'elasticsearch'

  directory "#{es_conf.path_pid}-#{default_config_name}" do
    path es_conf.path_pid
    owner es_user.username
    group es_user.groupname
    mode '0755'
    recursive true
    action :create
  end

  default_conf_dir = platform_family?('rhel', 'amazon') ? '/etc/sysconfig' : '/etc/default'

  entrypoint = new_resource.install_type == 'tarball' ? '/bin/elasticsearch' : '/bin/systemd-entrypoint -p ${PID_DIR}/elasticsearch.pid --quiet'

  systemd_unit new_resource.service_name do
    content(
      Unit: {
        Description: 'Elasticsearch',
        Documentation: 'https://www.elastic.co',
        Wants: 'network-online.target',
        After: 'network-online.target',
      },
      Service: {
        Type: 'notify',
        RuntimeDirectory: 'elasticsearch',
        PrivateTmp: 'true',
        Environment: [
          "ES_HOME=#{es_conf.path_home}",
          'ES_PATH_CONF=/etc/elasticsearch',
          "PID_DIR=#{es_conf.path_pid}",
          'ES_SD_NOTIFY=true',
        ],
        EnvironmentFile: "-#{default_conf_dir}/#{new_resource.service_name}",
        WorkingDirectory: "#{es_conf.path_home}",
        User: es_user.username,
        Group: es_user.groupname,
        ExecStart: "#{es_conf.path_home}#{entrypoint}",
        StandardOutput: 'journal',
        StandardError: 'inherit',
        LimitNOFILE: '65535',
        LimitNPROC: '4096',
        LimitAS: 'infinity',
        LimitFSIZE: 'infinity',
        TimeoutStopSec: '0',
        KillSignal: 'SIGTERM',
        KillMode: 'process',
        SendSIGKILL: 'no',
        SuccessExitStatus: '143',
        TimeoutStartSec: '900',
      },
      Install: {
        WantedBy: 'multi-user.target',
      }
    )
    verify false
    action :create
    unit_name "#{new_resource.service_name}.service"
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
