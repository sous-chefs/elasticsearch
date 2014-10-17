# Encoding: utf-8
#
# Cookbook Name:: elasticsearch
# Recipe:: default
#

include_recipe 'chef-sugar'
include_recipe 'curl'

ruby_block 'dummy_block for test coverage' do
  block do
    # some Ruby code
  end
  action :run
end
