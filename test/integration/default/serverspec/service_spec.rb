require_relative 'spec_helper'

# normal elasticsearch service with defaults
describe service('elasticsearch') do
  it { should be_enabled }
end
