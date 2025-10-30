# test fixture to validate default service configuration (no restart policy)

# Basic installation and user setup
elasticsearch_user 'elasticsearch'

elasticsearch_install 'elasticsearch' do
  type 'package'
end

elasticsearch_configure 'elasticsearch' do
  allocated_memory '256m'
  action :manage
end

# Test service with default configuration (no restart policy)
elasticsearch_service 'elasticsearch' do
  service_actions [:enable, :start]
end
