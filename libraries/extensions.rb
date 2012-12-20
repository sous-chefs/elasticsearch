Dir.glob( [ File.expand_path('../extensions', __FILE__), '*.rb' ].join('/') ).each do |lib|
  Chef::Log.debug "Loading extension: #{File.basename(lib)}"
  require lib
end

module Extensions
end
