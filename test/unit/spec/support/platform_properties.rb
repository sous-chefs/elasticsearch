require 'json'

def load_platform_properties(args)
  platform_file_str = "../../../fixtures/platform/#{args[:platform]}/#{args[:platform_version]}.json"
  platform_file_name = File.join(File.dirname(__FILE__), platform_file_str)
  platform_str = '{}'
  platform_str = IO.read(platform_file_name) if File.exist?(platform_file_name)
  JSON.parse(platform_str, symbolize_names: false)
end
