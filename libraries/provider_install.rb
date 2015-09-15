require 'poise'

class Chef
  # Chef Provider for installing or removing Elasticsearch from package or tarball
  # downloaded from elasticsearch.org and installed by package manager or ark resource
  class Provider::ElasticsearchInstall < Provider
    include Poise
    include ElasticsearchCookbook::Helpers
    provides :elasticsearch_install if respond_to?(:provides)

    def action_install
      install_type = determine_install_type(new_resource, node)
      if install_type == 'tarball' || install_type == 'tar'
        install_tarball_wrapper_action
      elsif install_type == 'package'
        install_package_wrapper_action
      else
        raise "#{install_type} is not a valid install type"
      end
    end

    def action_remove
      if install_type == 'tarball' || install_type == 'tar'
        remove_tarball_wrapper_action
      elsif install_type == 'package'
        remove_package_wrapper_action
      else
        raise "#{install_type} is not a valid install type"
      end
    end

    protected

    def install_package_wrapper_action
      converge_by("#{new_resource.name} - install package") do
        notifying_block do
          download_url = determine_download_url(new_resource, node)
          filename = download_url.split('/').last
          checksum = determine_download_checksum(new_resource, node)
          package_options = new_resource.package_options

          remote_file "#{Chef::Config[:file_cache_path]}/#{filename}" do
            source download_url
            checksum checksum
            mode 00644
          end

          if node['platform_family'] == 'debian'
            dpkg_package "#{Chef::Config[:file_cache_path]}/#{filename}" do
              options package_options
              action :install
            end
          else
            package "#{Chef::Config[:file_cache_path]}/#{filename}" do
              options package_options
              action :install
            end
          end
        end
      end
    end

    def remove_package_wrapper_action
      converge_by("#{new_resource.name} - remove package") do
        notifying_block do
          package_url = get_package_url(new_resource, node)
          filename = package_url.split('/').last

          if node['platform_family'] == 'debian'
            dpkg_package "#{Chef::Config[:file_cache_path]}/#{filename}" do
              action :remove
            end
          else
            package "#{Chef::Config[:file_cache_path]}/#{filename}" do
              action :remove
            end
          end
        end
      end
    end

    def install_tarball_wrapper_action
      converge_by("#{new_resource.name} - install source") do
        notifying_block do
          include_recipe 'ark'
          include_recipe 'curl'

          ark "elasticsearch" do
            url   determine_download_url(new_resource, node)
            owner new_resource.owner
            group new_resource.group
            version determine_version(new_resource, node)
            has_binaries ['bin/elasticsearch', 'bin/plugin']
            checksum determine_download_checksum(new_resource, node)
            prefix_root   get_tarball_root_dir(new_resource, node)
            prefix_home   get_tarball_home_dir(new_resource, node)

            not_if do
              link   = "#{new_resource.dir}/elasticsearch"
              target = "#{new_resource.dir}/elasticsearch-#{determine_version(new_resource, node)}"
              binary = "#{target}/bin/elasticsearch"

              ::File.directory?(link) && ::File.symlink?(link) && ::File.readlink(link) == target && ::File.exists?(binary)
            end
          end
        end
      end
    end

    def remove_tarball_wrapper_action
      converge_by("#{new_resource.name} - remove source") do
        notifying_block do
          # remove the symlink to this version
          link "#{new_resource.dir}/elasticsearch" do
            action :delete
            only_if do
              link   = "#{new_resource.dir}/elasticsearch"
              target = "#{new_resource.dir}/elasticsearch-#{determine_version(new_resource, node)}"

              ::File.directory?(link) && ::File.symlink?(link) && ::File.readlink(link) == target
            end
          end

          # remove the specific version
          directory "#{new_resource.dir}/elasticsearch-#{determine_version(new_resource, node)}" do
            action :delete
          end
        end
      end
    end

  end
end
