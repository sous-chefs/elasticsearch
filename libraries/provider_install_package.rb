require 'poise'

class Chef
  # Chef Provider for installing or removing Elasticsearch from package
  # downloaded from elasticsearch.org and installed by the package manager
  class Provider::ElasticsearchInstallPackage < Provider
    include Poise
    include ElasticsearchCookbook::Helpers
    provides :elasticsearch_install, platform_family: [ "rhel", "fedora" ] if respond_to?(:provides)

    def action_install
      converge_by("#{new_resource.name} - install package") do
        notifying_block do
          package_url = get_package_url(new_resource, node)
          filename = package_url.split('/').last
          checksum = get_package_checksum(new_resource, node)
          package_options = new_resource.package_options

          download_package(package_url, "#{Chef::Config[:file_cache_path]}/#{filename}", checksum)
          install_package("#{Chef::Config[:file_cache_path]}/#{filename}", package_options)
        end
      end
    end

    def action_remove
      converge_by("#{new_resource.name} - remove package") do
        notifying_block do
          package_url = get_package_url(new_resource, node)
          filename = package_url.split('/').last

          remove_package("#{Chef::Config[:file_cache_path]}/#{filename}")
        end
      end
    end

    class << self
      # supports the given resource and action (late binding)
      def supports?(resource, action)
        resource.type == :package
      end
    end

    protected

    def download_package(url, path, checksum)
      remote_file path do
        source url
        checksum checksum
        mode 00644
      end
    end

    def install_package(path, package_options)
      package path do
        options package_options
        action :install
      end
    end

    def remove_package(path)
      package path do
        action :remove
      end
    end

  end
end
