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

include_recipe 'chef-sugar'

# see README.md
include_recipe 'elasticsearch::default'

# by default, no plugins, but we do the x-pack
elasticsearch_plugin 'x-pack' do
  notifies :restart, 'elasticsearch_service[elasticsearch]', :delayed
end

# remove a non-existent plugin
elasticsearch_plugin 'pleasedontexist' do
  action :remove
  notifies :restart, 'elasticsearch_service[elasticsearch]', :delayed
end
