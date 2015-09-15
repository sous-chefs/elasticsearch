
class Chef
  class Provider::ElasticsearchPlugin < Chef::Provider::LWRPBase
    include ElasticsearchCookbook::Helpers
    include Chef::Mixin::ShellOut

    action :install do
      name    = new_resource.plugin_name
      version = new_resource.version ? "/#{new_resource.version}" : nil
      url     = new_resource.url     ? " -url #{new_resource.url}" : nil

      raise 'Could not determine the plugin directory. Please set plugin_dir on this resource.' unless new_resource.plugin_dir
      converge_by("install plugin #{name}") do

        plugin_exists = Dir.entries(new_resource.plugin_dir).any? do |plugin|
          next if plugin =~ /^\./
          name.include? plugin
        end rescue false

        unless plugin_exists
          # automatically raises on error, logs command output
          shell_out!("#{new_resource.bindir}/plugin -install #{name}#{version}#{url}".split(' '), user: new_resource.user, group: new_resource.group)
          new_resource.updated_by_last_action(true)
        end
      end
    end # action
  end # provider
end # chef class
