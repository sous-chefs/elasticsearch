require_relative 'spec_helper'

# normal user with defaults
describe group('elasticsearch') do
  it { should exist }
end

describe user('elasticsearch') do
  it { should exist }
  it { should have_home_directory '/usr/local/elasticsearch' }
  it { should have_login_shell '/bin/bash' }
  it { should belong_to_group 'elasticsearch' }
end
