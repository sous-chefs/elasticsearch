require_relative 'spec_helper'

shared_examples_for 'elasticsearch service' do |service_name = 'elasticsearch', args = {}|
  describe service(service_name) do
    it { should be_enabled }
  end
end
