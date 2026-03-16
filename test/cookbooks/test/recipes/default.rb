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

elasticsearch_configure 'elasticsearch'

elasticsearch_service 'elasticsearch'

elasticsearch_plugin 'analysis-icu' do
  notifies :restart, 'elasticsearch_service[elasticsearch]', :delayed
end

elasticsearch_plugin 'mapper-size' do
  notifies :restart, 'elasticsearch_service[elasticsearch]', :delayed
end
