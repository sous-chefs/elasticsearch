# Cookbook Name:: elasticsearch_test
# Recipe:: shieldwatcher

include_recipe "#{cookbook_name}::default_with_plugins"

# test these since they need to write to 'bin' directory
%w(license shield watcher).each do |plugin_name|
  elasticsearch_plugin plugin_name do
    notifies :restart, 'elasticsearch_service[elasticsearch]', :delayed
  end
end
