
# Chef Provider for installing or removing Elasticsearch from package or tarball
# downloaded from elasticsearch.org and installed by package manager or ark resource
class ElasticsearchCookbook::InstallProvider < Chef::Provider::LWRPBase
  include ElasticsearchCookbook::Helpers
  include Chef::DSL::IncludeRecipe
  provides :elasticsearch_install

  use_inline_resources if defined?(use_inline_resources)

  def whyrun_supported?
    false
  end

  action :install do
    install_type = determine_install_type(new_resource, node)
    unless new_resource.version
      new_resource.version determine_version(new_resource, node)
    end

    if install_type == 'tarball' || install_type == 'tar'
      install_tarball_wrapper_action
    elsif install_type == 'package'
      install_package_wrapper_action
    else
      raise "#{install_type} is not a valid install type"
    end
  end

  action :remove do
    install_type = determine_install_type(new_resource, node)

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
    download_url = determine_download_url(new_resource, node)
    filename = download_url.split('/').last
    checksum = determine_download_checksum(new_resource, node)
    package_options = new_resource.package_options

    unless checksum
      Chef::Log.warn("No checksum was provided for #{download_url}, this may download a new package on every chef run!")
    end

    remote_file_r = remote_file "#{Chef::Config[:file_cache_path]}/#{filename}" do
      source download_url
      checksum checksum
      mode 00644
      action :nothing
    end
    remote_file_r.run_action(:create)
    new_resource.updated_by_last_action(true) if remote_file_r.updated_by_last_action?

    pkg_r = if node['platform_family'] == 'debian'
              dpkg_package "#{Chef::Config[:file_cache_path]}/#{filename}" do
                options package_options
                action :nothing
              end
            else
              package "#{Chef::Config[:file_cache_path]}/#{filename}" do
                options package_options
                action :nothing
              end
            end

    pkg_r.run_action(:install)
    new_resource.updated_by_last_action(true) if pkg_r.updated_by_last_action?
  end

  def remove_package_wrapper_action
    package_url = determine_download_url(new_resource, node)
    filename = package_url.split('/').last

    pkg_r = if node['platform_family'] == 'debian'
              dpkg_package "#{Chef::Config[:file_cache_path]}/#{filename}" do
                action :nothing
              end
            else
              package "#{Chef::Config[:file_cache_path]}/#{filename}" do
                action :nothing
              end
            end

    pkg_r.run_action(:remove)
    new_resource.updated_by_last_action(true) if pkg_r.updated_by_last_action?
  end

  def install_tarball_wrapper_action
    include_recipe 'ark'

    es_user = find_es_resource(run_context, :elasticsearch_user, new_resource)

    ark_r = ark 'elasticsearch' do
      url   determine_download_url(new_resource, node)
      owner es_user.username
      group es_user.groupname
      version determine_version(new_resource, node)
      has_binaries ['bin/elasticsearch', 'bin/plugin']
      checksum determine_download_checksum(new_resource, node)
      prefix_root   new_resource.dir[new_resource.type]
      prefix_home   new_resource.dir[new_resource.type]

      not_if do
        link   = "#{new_resource.dir}/elasticsearch"
        target = "#{new_resource.dir}/elasticsearch-#{determine_version(new_resource, node)}"
        binary = "#{target}/bin/elasticsearch"

        ::File.directory?(link) && ::File.symlink?(link) && ::File.readlink(link) == target && ::File.exist?(binary)
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
