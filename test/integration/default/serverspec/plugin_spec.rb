require_relative 'spec_helper'

describe file("/usr/local/elasticsearch/plugins/head") do
  it { should be_directory }
  it { should be_owned_by 'elasticsearch' }
  it { should be_grouped_into 'elasticsearch' }
end
