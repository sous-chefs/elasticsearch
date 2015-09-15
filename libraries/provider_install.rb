
class Chef
  # Chef Provider for installing or removing Elasticsearch from package or tarball
  # downloaded from elasticsearch.org and installed by package manager or ark resource
  class Provider::ElasticsearchInstall < Chef::Provider::LWRPBase
    include ElasticsearchCookbook::Helpers
    provides :elasticsearch_install if respond_to?(:provides)

    action :install do
      install_type = determine_install_type(new_resource, node)
      converge_by("#{new_resource.name} - install #{install_type}") do
        if install_type == 'tarball' || install_type == 'tar'
          install_tarball_wrapper_action
        elsif install_type == 'package'
          install_package_wrapper_action
        else
          raise "#{install_type} is not a valid install type"
        end
      end
    end

    action :remove do
      install_type = determine_install_type(new_resource, node)
      converge_by("#{new_resource.name} - remove #{install_type}") do
        if install_type == 'tarball' || install_type == 'tar'
          remove_tarball_wrapper_action
        elsif install_type == 'package'
          remove_package_wrapper_action
        else
          raise "#{install_type} is not a valid install type"
        end
      end
    end

    protected

    def install_package_wrapper_action
      download_url = determine_download_url(new_resource, node)
      filename = download_url.split('/').last
      checksum = determine_download_checksum(new_resource, node)
      package_options = new_resource.package_options

      remote_file_r = remote_file "#{Chef::Config[:file_cache_path]}/#{filename}" do
        source download_url
        checksum checksum
        mode 00644
        action :nothing
      end
      remote_file_r.run_action(:create)
      new_resource.updated_by_last_action(true) if remote_file_r.updated_by_last_action?

      if node['platform_family'] == 'debian'
        pkg_r = dpkg_package "#{Chef::Config[:file_cache_path]}/#{filename}" do
          options package_options
          action :nothing
        end
        pkg_r.run_action(:install)
        new_resource.updated_by_last_action(true) if pkg_r.updated_by_last_action?
      else
        pkg_r = package "#{Chef::Config[:file_cache_path]}/#{filename}" do
          options package_options
          action :nothing
        end
        pkg_r.run_action(:install)
        new_resource.updated_by_last_action(true) if pkg_r.updated_by_last_action?
      end
    end

    def remove_package_wrapper_action
      package_url = get_package_url(new_resource, node)
      filename = package_url.split('/').last

      if node['platform_family'] == 'debian'
        pkg_r = dpkg_package "#{Chef::Config[:file_cache_path]}/#{filename}" do
          action :nothing
        end
        pkg_r.run_action(:remove)
        new_resource.updated_by_last_action(true) if pkg_r.updated_by_last_action?
      else
        pkg_r = package "#{Chef::Config[:file_cache_path]}/#{filename}" do
          action :nothing
        end
        pkg_r.run_action(:remove)
        new_resource.updated_by_last_action(true) if pkg_r.updated_by_last_action?
      end
    end

    def install_tarball_wrapper_action
      include_recipe 'ark'
      include_recipe 'curl'

      ark_r = ark "elasticsearch" do
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
        action :nothing
      end
      ark_r.run_action(:install)
      new_resource.updated_by_last_action(true) if ark_r.updated_by_last_action?
    end

    def remove_tarball_wrapper_action
      # remove the symlink to this version
      link_r = link "#{new_resource.dir}/elasticsearch" do
        only_if do
          link   = "#{new_resource.dir}/elasticsearch"
          target = "#{new_resource.dir}/elasticsearch-#{determine_version(new_resource, node)}"

          ::File.directory?(link) && ::File.symlink?(link) && ::File.readlink(link) == target
        end
        action :nothing
      end
      link_r.run_action(:delete)
      new_resource.updated_by_last_action(true) if link_r.updated_by_last_action?

      # remove the specific version
      d_r = directory "#{new_resource.dir}/elasticsearch-#{determine_version(new_resource, node)}" do
        action :nothing
      end
      d_r.run_action(:delete)
      new_resource.updated_by_last_action(true) if d_r.updated_by_last_action?
    end
  end
end
