# Encoding: utf-8
#
# Cookbook Name:: elasticsearch
# Recipe:: default
#

include_recipe 'chef-sugar'

# see README.md and test/fixtures/cookbooks for more examples!
elasticsearch_user 'elasticsearch'
elasticsearch_install 'elasticsearch' do
  type node['elasticsearch']['install_type'].to_sym # since TK can't symbol.
end
elasticsearch_configure 'elasticsearch'
elasticsearch_service 'elasticsearch' do 
  node['elasticsearch']['service'].each do |key, value|
    # Skip nils, use false if you want to disable something.
    send(key, value) unless value.nil?
  end
end

# by default, no plugins
