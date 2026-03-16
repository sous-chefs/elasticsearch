# frozen_string_literal: true

require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
end

def stub_resources
  stub_command('/usr/share/elasticsearch/bin/x-pack/users list | grep -q testuser').and_return(0)
end

def supported_platforms
  {
    'ubuntu' => ['22.04', '24.04'],
    'redhat' => %w(8 9 10),
  }
end
