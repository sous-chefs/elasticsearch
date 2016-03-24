#
# Cookbook Name:: elasticsearch_test
# Recipe:: doubleinstances
#
# Example of creating two ES instances on a single server

elasticsearch_user 'elasticsearch'

# for package install, share the various paths across instances
elasticsearch_install 'elasticsearch' do
  type :package
end

elasticsearch_plugin 'elasticsearch_head' do
  instance_name 'alpha'
  url 'mobz/elasticsearch-head'
  # notifies :restart, "elasticsearch_service[elasticsearch]", :delayed
  not_if { ::File.exist?('/usr/share/elasticsearch/plugins/head') }
end

settings = {
  alpha: {
    http_port: 9201,
    transport_port: 9301,
    discovery_hosts: '127.0.0.1:9302'
  },
  beta: {
    http_port: 9202,
    transport_port: 9302,
    discovery_hosts: '127.0.0.1:9301'
  }
}

%w(alpha beta).each do |instance_name|
  elasticsearch_configure "elasticsearch_#{instance_name}" do
    instance_name instance_name
    path_home package:    '/usr/share/elasticsearch'
    path_conf package:    "/etc/elasticsearch-#{instance_name}"
    path_data package:    "/var/lib/elasticsearch/#{instance_name}"
    path_logs package:    "/var/log/elasticsearch-#{instance_name}"
    path_pid package:     "/var/run/elasticsearch-#{instance_name}"
    path_plugins package: '/usr/share/elasticsearch/bin/plugin'
    path_bin package:     '/usr/share/elasticsearch/bin'
    allocated_memory '256m'
    configuration(
      'cluster.name' => 'mycluster',
      'node.name' => "node_#{instance_name}",
      'network.host' => '127.0.0.1',
      'http.port' => settings[instance_name.to_sym][:http_port].to_s,
      'transport.tcp.port' => settings[instance_name.to_sym][:transport_port].to_s,
      'discovery.zen.ping.unicast.hosts' => settings[instance_name.to_sym][:discovery_hosts].to_s
    )
  end

  elasticsearch_service "elasticsearch_#{instance_name}" do
    instance_name instance_name
    service_actions [:enable, :start]
  end
end
