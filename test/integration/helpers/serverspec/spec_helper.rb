require 'serverspec'

base_path = File.dirname(__FILE__)
Dir["#{base_path}/*_examples.rb"].each do |ex|
  require_relative ex
end

set :backend, :exec
set :path, '/usr/sbin:/sbin:/usr/local/sbin:/bin:/usr/bin:$PATH'
