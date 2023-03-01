#
# Cookbook:: test
# Recipe:: default_with_plugins
#
# This cookbook is designed to be just elasticsearch::default plus installing
# some plugins. We want to test the default plugin resource without any
# interesting overrides, but don't want to ship that as a recipe in the main
# cookbook (unlike install, configure, and service, which we do ship in the
# default cookbook).

elasticsearch_user 'elasticsearch' do
  node['elasticsearch']['user'].each do |key, value|
    # Skip nils, use false if you want to disable something.
    send(key, value) unless value.nil?
  end
end

elasticsearch_install 'elasticsearch' do
  node['elasticsearch']['install'].each do |key, value|
    # Skip nils, use false if you want to disable something.
    send(key, value) unless value.nil?
  end
end

# elasticsearch_configure 'elasticsearch' do
#   node['elasticsearch']['configure'].each do |key, value|
#     # Skip nils, use false if you want to disable something.
#     send(key, value) unless value.nil?
#   end
# end

elasticsearch_service 'elasticsearch' do
  node['elasticsearch']['service'].each do |key, value|
    # Skip nils, use false if you want to disable something.
    send(key, value) unless value.nil?
  end
end

# by default, no plugins
node['elasticsearch']['plugin'].each do |plugin_name, plugin_value|
  elasticsearch_plugin plugin_name do
    plugin_value.each do |key, value|
      # Skip nils, use false if you want to disable something.
      send(key, value) unless value.nil?
    end
  end
end

# by default, no plugins, but we'd like to try one
elasticsearch_plugin 'analysis-icu' do
  notifies :restart, 'elasticsearch_service[elasticsearch]', :delayed
end

# remove a non-existent plugin
elasticsearch_plugin 'pleasedontexist' do
  action :remove
  notifies :restart, 'elasticsearch_service[elasticsearch]', :delayed
end
