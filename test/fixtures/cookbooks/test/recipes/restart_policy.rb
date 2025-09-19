# test fixture to validate restart_policy functionality

# Basic installation and user setup
elasticsearch_user 'elasticsearch'

elasticsearch_install 'elasticsearch' do
  type 'package'
end

elasticsearch_configure 'elasticsearch' do
  allocated_memory '256m'
  configuration('node.name' => 'restart_test_node')
  action :manage
end

# Test service with restart policy
elasticsearch_service 'elasticsearch' do
  restart_policy 'on-failure'
  restart_sec 30
  service_actions [:enable, :start]
end