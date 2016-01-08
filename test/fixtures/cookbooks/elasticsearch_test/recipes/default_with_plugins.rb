# Encoding: utf-8
#
# Cookbook Name:: elasticsearch_test
# Recipe:: default_with_plugins
#
# This cookbook is designed to be just elasticsearch::default plus installing
# some plugins. We want to test the default plugin resource without any
# interesting overrides, but don't want to ship that as a recipe in the main
# cookbook (unlike install, configure, and service, which we do ship in the
# default cookbook).

# see README.md and test/fixtures/cookbooks for more examples!
include_recipe 'chef-sugar'

# see README.md and test/fixtures/cookbooks for more examples!
elasticsearch_user 'elasticsearch'
elasticsearch_install 'elasticsearch' do
  type node['elasticsearch']['install_type'].to_sym # since TK can't symbol.
end
elasticsearch_configure 'elasticsearch'
elasticsearch_service 'elasticsearch' do
  service_actions [:enable, :start]
end

# by default, no plugins, but we do one here.
elasticsearch_plugin 'head' do
  url 'mobz/elasticsearch-head'
  notifies :restart, 'elasticsearch_service[elasticsearch]', :delayed
end

# remove an installed plugin
elasticsearch_plugin 'kopf' do
  url 'lmenezes/elasticsearch-kopf'
  action [:install, :remove]
  notifies :restart, 'elasticsearch_service[elasticsearch]', :delayed
end

# remove a non-existent plugin
elasticsearch_plugin 'pleasedontexist' do
  action :remove
  notifies :restart, 'elasticsearch_service[elasticsearch]', :delayed
end
