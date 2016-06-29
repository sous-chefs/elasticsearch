require_relative 'spec_helper'

shared_examples_for 'chef version' do |version, _args = {}|
  describe package('chef') do
    it { should be_installed }
  end

  describe command('chef-client -v') do
    its(:stdout) { should match(/Chef: #{version}/) }
  end
end
