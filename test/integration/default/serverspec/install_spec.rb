require_relative 'spec_helper'

# normal elasticsearch install with defaults
describe file('/usr/local/elasticsearch-1.5.0') do
  it { should be_directory }
end

describe file('/usr/local/elasticsearch') do
  it { should be_symlink }
end

describe file('/usr/local/bin/elasticsearch') do
  it { should be_symlink }
  it { should be_linked_to('/usr/local/elasticsearch-1.5.0/bin/elasticsearch') }
end
