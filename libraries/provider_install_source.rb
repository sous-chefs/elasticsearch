require 'poise'

class Chef
  # Chef Provider for installing or removing Elasticsearch from tarball
  # downloaded from elasticsearch.org and unpacked into (by default) /usr/local
  class Provider::ElasticsearchInstallSource < Provider
    include Poise
    include ElasticsearchCookbook::Helpers
    provides :elasticsearch_install if respond_to?(:provides)

    def action_install
      converge_by("#{new_resource.name} - install source") do
        notifying_block do
          include_recipe 'ark'
          include_recipe 'curl'

          ark "elasticsearch" do
            url   new_resource.tarball_url
            owner new_resource.owner
            group new_resource.group
            version new_resource.version
            has_binaries ['bin/elasticsearch', 'bin/plugin']
            checksum new_resource.tarball_checksum
            prefix_root   get_tarball_root_dir(new_resource, node)
            prefix_home   get_tarball_home_dir(new_resource, node)

            not_if do
              link   = "#{new_resource.dir}/elasticsearch"
              target = "#{new_resource.dir}/elasticsearch-#{new_resource.version}"
              binary = "#{target}/bin/elasticsearch"

              ::File.directory?(link) && ::File.symlink?(link) && ::File.readlink(link) == target && ::File.exists?(binary)
            end
          end
        end
      end
    end

    def action_remove
      converge_by("#{new_resource.name} - remove source") do
        notifying_block do
          # remove the symlink to this version
          link "#{new_resource.dir}/elasticsearch" do
            action :delete
            only_if do
              link   = "#{new_resource.dir}/elasticsearch"
              target = "#{new_resource.dir}/elasticsearch-#{new_resource.version}"

              ::File.directory?(link) && ::File.symlink?(link) && ::File.readlink(link) == target
            end
          end

          # remove the specific version
          directory "#{new_resource.dir}/elasticsearch-#{new_resource.version}" do
            action :delete
          end
        end
      end
    end

    class << self
      # supports the given resource and action (late binding)
      def supports?(resource, action)
        resource.type == :tarball
      end
    end

  end
end
