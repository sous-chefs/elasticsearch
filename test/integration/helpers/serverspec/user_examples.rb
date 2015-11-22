require_relative 'spec_helper'

shared_examples_for 'elasticsearch user' do |args = {}|
  expected_user = args[:user] || 'elasticsearch'
  expected_group = args[:group] || expected_user || 'elasticsearch'
  # expected_home = args[:home] || (package? ? "/usr/share/#{expected_user}" : "/usr/local/#{expected_user}")
  expected_shell = args[:shell] || '/bin/bash'

  describe group(expected_group) do
    it { should exist }
    it { should have_gid(args[:gid]) } if args[:gid]
  end

  describe user(expected_user) do
    it { should exist }
    it { should have_login_shell expected_shell }
    it { should belong_to_group expected_group }
    it { should have_uid(args[:uid]) } if args[:uid]
  end
end
