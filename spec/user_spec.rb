require_relative 'spec_helper'

describe 'test::user' do
  before { stub_resources }
  supported_platforms.each do |platform, versions|
    versions.each do |version|
      context "on #{platform.capitalize} #{version}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version, step_into: ['elasticsearch_user']) do |node, server|
            node_resources(node) # data for this node
            stub_chef_zero(platform, version, server) # stub other nodes in chef-zero
          end.converge(described_recipe)
        end

        it 'creates elasticsearch user deleteme in group foo' do
          expect(chef_run).to create_elasticsearch_user('deleteme')
        end

        it 'deletes user deleteme' do
          expect(chef_run).to remove_elasticsearch_user('deleteme')
        end
      end
    end
  end
end
