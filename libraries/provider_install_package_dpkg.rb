require 'poise'

class Chef
  # Chef Provider for installing or removing Elasticsearch from package
  # downloaded from elasticsearch.org and installed by dpkg. We break this out
  # because the package resource chooses an apt provider which cannot install
  # from a file. dpkg_package, however, can install from a file directly.
  class Provider::ElasticsearchInstallPackageDpkg <  Chef::Provider::ElasticsearchInstallPackage
    provides :elasticsearch_install, platform_family: [ "debian", "ubuntu" ] if respond_to?(:provides)

    def install_package(path, package_options)
      dpkg_package path do
        options package_options
        action :install
      end
    end

    def remove_package(path)
      dpkg_package path do
        action :remove
      end
    end

    class << self
      # supports the given resource and action (late binding)
      def supports?(resource, action)
        resource.type == :package
      end
    end

  end
end
