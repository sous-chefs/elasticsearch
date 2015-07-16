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

      # nasty workaround to find a nice default for plugin dir
      unless new_resource.plugin_dir
        found_installs = run_context.resource_collection.select { |r| r.instance_variable_get(:@resource_name) == :elasticsearch_install }

        unless found_installs.empty?

          install_resource = found_installs.first
          es_version = install_resource.instance_variable_get(:@version)
          es_dir = get_tarball_root_dir(install_resource, node)

          new_resource.plugin_dir "#{es_dir}/elasticsearch-#{es_version}/plugins"
        end
      end

      raise 'Could not determine the plugin directory. Please set plugin_dir on this resource.' unless new_resource.plugin_dir

      return if Dir.entries(new_resource.plugin_dir).any? do |plugin|
        next if plugin =~ /^\./
        name.include? plugin
      end rescue false

      directory new_resource.plugin_dir do
        owner new_resource.user
        group new_resource.group
        mode 0755
        recursive true
      end

      # automatically raises on error, logs command output
      shell_out!("#{new_resource.bindir}/plugin -install #{name}#{version}#{url}".split(' '))

      # Ensure proper permissions
      shell_out!("chown -R #{new_resource.user}:#{new_resource.group} #{new_resource.plugin_dir}".split(' '))
    end # action
  end # provider
end # chef class
