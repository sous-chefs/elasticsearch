require 'poise'

class Chef
  class Provider::ElasticsearchPlugin < Provider
    include Poise
    include ElasticsearchCookbook::Helpers
    include Chef::Mixin::ShellOut

    def action_install
      name    = new_resource.plugin_name
      version = new_resource.version ? "/#{new_resource.version}" : nil
      url     = new_resource.url     ? " -url #{new_resource.url}" : nil

      raise 'Could not determine the plugin directory. Please set plugin_dir on this resource.' unless new_resource.plugin_dir

      return if Dir.entries(new_resource.plugin_dir).any? do |plugin|
        next if plugin =~ /^\./
        name.include? plugin
      end rescue false

      # automatically raises on error, logs command output
      shell_out!("#{new_resource.bindir}/plugin -install #{name}#{version}#{url}".split(' '), user: new_resource.user, group: new_resource.group)

      # Ensure proper permissions
      # shell_out!("chown -R #{new_resource.user}:#{new_resource.group} #{new_resource.plugin_dir}".split(' '))
    end # action
  end # provider
end # chef class
