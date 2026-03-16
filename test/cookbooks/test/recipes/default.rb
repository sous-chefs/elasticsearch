# frozen_string_literal: true

#
# Cookbook:: test
# Recipe:: default
#
# Primary smoke test: install via repository, configure, and start Elasticsearch

elasticsearch_user 'elasticsearch'

elasticsearch_install 'elasticsearch' do
  type 'repository'
end

# ES 8.x auto-configures security on package install, adding SSL keystore
# entries and certs. Explicitly disable security and SSL so the vendor
# keystore entries don't conflict with the cookbook-managed elasticsearch.yml.
elasticsearch_configure 'elasticsearch' do
  configuration(
    'xpack.security.enabled' => false,
    'xpack.security.transport.ssl.enabled' => false,
    'xpack.security.http.ssl.enabled' => false
  )
end

elasticsearch_service 'elasticsearch'

elasticsearch_plugin 'analysis-icu' do
  notifies :restart, 'elasticsearch_service[elasticsearch]', :delayed
end

elasticsearch_plugin 'mapper-size' do
  notifies :restart, 'elasticsearch_service[elasticsearch]', :delayed
end
