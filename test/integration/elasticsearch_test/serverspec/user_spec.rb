require_relative 'spec_helper'

# extra user to test all non-defaults
describe group('bar') do
  it { should exist }
  it { should have_gid(2222) }
end

describe user('foo') do
  it { should exist }
  it { should have_uid(1111) }
  it { should have_home_directory '/usr/local/myhomedir' }
  it { should have_login_shell '/bin/sh' }
  it { should belong_to_group 'bar' }
end

describe group('deleteme') do
  it { should_not exist }
end

describe user('deleteme') do
  it { should_not exist }
end
