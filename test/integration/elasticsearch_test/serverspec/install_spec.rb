require_relative 'spec_helper'

# check package and source installs, all kinds of non-default settings

# package test first
describe package('elasticsearch') do
  it { should be_installed }
end

# source install test
describe file('/usr/local/awesome/elasticsearch-1.5.0') do
  it { should be_directory }
  it { should be_owned_by 'foo' }
  it { should be_grouped_into 'bar' }
end

describe file('/usr/local/awesome/elasticsearch') do
  it { should be_symlink }
end

describe file('/usr/local/bin/elasticsearch') do
  it { should be_symlink }
  it { should be_linked_to('/usr/local/awesome/elasticsearch-1.5.0/bin/elasticsearch') }
end
