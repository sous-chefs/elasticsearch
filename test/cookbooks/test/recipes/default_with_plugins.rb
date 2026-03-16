#
# Cookbook:: test
# Recipe:: default_with_plugins
#
# This cookbook is designed to be just elasticsearch::default plus installing
# some plugins. We want to test the default plugin resource without any
# interesting overrides, but don't want to ship that as a recipe in the main
# cookbook (unlike install, configure, and service, which we do ship in the
# default cookbook).

elasticsearch_user 'elasticsearch'

elasticsearch_install 'elasticsearch' do
  type node['elasticsearch']['install']['type']
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

# remove a non-existent plugin
elasticsearch_plugin 'pleasedontexist' do
  action :remove
  notifies :restart, 'elasticsearch_service[elasticsearch]', :delayed
end
