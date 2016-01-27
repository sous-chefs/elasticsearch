require 'serverspec'

base_path = File.dirname(__FILE__)
Dir["#{base_path}/*_examples.rb"].each do |ex|
  require_relative ex
end

set :backend, :exec
set :path, '/usr/sbin:/sbin:/usr/local/sbin:/bin:/usr/bin:$PATH'

def rhel?
  %w(redhat).include?(os[:family])
end

def debian?
  %w(ubuntu debian).include?(os[:family])
end

def package?
  return system('dpkg -l elasticsearch >/dev/null 2>&1') if debian?
  return system('rpm -qa | grep elasticsearch >/dev/null 2>&1') if rhel?
  fail "I don't recognize #{os[:family]}, so I can't check for an elasticsearch package"
end

def tarball?
  return !package?
end
