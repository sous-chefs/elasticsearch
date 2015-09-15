require_relative 'spec_helper'

# normal elasticsearch install with defaults
describe file('/usr/local/elasticsearch-1.7.2') do
  it { should be_directory }
end

describe file('/usr/local/elasticsearch') do
  it { should be_symlink }
end

describe file('/usr/local/bin/elasticsearch') do
  it { should be_symlink }
  it { should be_linked_to('/usr/local/elasticsearch-1.7.2/bin/elasticsearch') }
end
