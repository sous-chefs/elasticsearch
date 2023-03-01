require_relative 'spec_helper'

describe 'test::tarball' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_install']) do |node, server|
            node_resources(node) # data for this node
            stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
          end.converge(described_recipe)
        end
      end
    end
  end
end

describe 'test::package' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_install']) do |node, server|
            node_resources(node) # data for this node
            stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
          end.converge(described_recipe)
        end
      end
    end
  end
end

describe 'test::tarball with bad version' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_install']) do |node, server|
            node_resources(node) # data for this node
            stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
            node.override['elasticsearch']['version'] = '99.99.99'
          end.converge('test::tarball')
        end
      end
    end
  end
end

describe 'test::tarball with bad low version' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_install']) do |node, server|
            node_resources(node) # data for this node
            stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
            node.override['elasticsearch']['version'] = '0.0.1'
          end.converge('test::tarball')
        end
      end
    end
  end
end

describe 'test::package with username foo' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      %w(repository package tarball).each do |install_type|
        context "Install Elasticsearch as #{install_type}" do
          let(:chef_run) do
            ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_install']) do |node, server|
              node_resources(node) # data for this node
              stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
              node.override['elasticsearch']['user']['username'] = 'foo'
              node.override['elasticsearch']['user']['groupname'] = 'bar'
              node.override['elasticsearch']['install']['type'] = install_type
            end.converge('test::default_with_plugins')
          end

          it 'converge status' do
            if install_type != 'tarball'
              expect { chef_run }.to raise_error(RuntimeError, /Custom usernames/)
            else
              expect { chef_run }.to_not raise_error
            end
          end
        end
      end
    end
  end
end
