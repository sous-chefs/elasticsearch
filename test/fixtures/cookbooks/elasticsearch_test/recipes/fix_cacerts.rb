#
# Cookbook Name:: elasticsearch_test
# Recipe:: fix_cacerts
#

# apparently some distros of Ubuntu don't have good SSL trust stores by default.
execute 'update-ca-certificates -f && update-ca-certificates -f' do
  only_if 'which update-ca-certificates'
end
