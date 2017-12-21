# Chef Provider for installing or removing Elasticsearch from package or tarball
# downloaded from elasticsearch.org and installed by package manager or ark resource
class ElasticsearchCookbook::InstallProvider < Chef::Provider::LWRPBase
  include ElasticsearchCookbook::Helpers
  include Chef::DSL::IncludeRecipe
  provides :elasticsearch_install

  def whyrun_supported?
    true # we only use core Chef resources that also support whyrun
  end

  def action_install
    if new_resource.type == 'tarball'
      install_tarball_wrapper_action
    elsif new_resource.type == 'package'
      install_package_wrapper_action
    elsif new_resource.type == 'repository'
      install_repo_wrapper_action
    else
      raise "#{install_type} is not a valid install type"
    end
  end

  def action_remove
    if new_resource.type == 'tarball'
      remove_tarball_wrapper_action
    elsif new_resource.type == 'package'
      remove_package_wrapper_action
    elsif new_resource.type == 'repository'
      remove_repo_wrapper_action
    else
      raise "#{install_type} is not a valid install type"
    end
  end

  protected

  def install_repo_wrapper_action
    if new_resource.enable_repository_actions
      if node['platform_family'] == 'debian'
        apt_r = apt_repo_resource
        apt_r.run_action(:add)
        new_resource.updated_by_last_action(true) if apt_r.updated_by_last_action?
      else
        yr_r = yum_repo_resource
        yr_r.run_action(:create)
        new_resource.updated_by_last_action(true) if yr_r.updated_by_last_action?
      end
    end

    if node['platform_family'] == 'rhel' && !new_resource.version.include?('-')
      # NB: yum repo packages are broken in Chef if you don't specify a release
      #     https://github.com/chef/chef/issues/4103
      new_resource.version = "#{new_resource.version}-1"
    end

    pkg_r = package 'elasticsearch' do
      options new_resource.package_options
      version new_resource.version
      action :nothing
    end

    pkg_r.run_action(:install)
    new_resource.updated_by_last_action(true) if pkg_r.updated_by_last_action?
  end

  def remove_repo_wrapper_action
    if new_resource.enable_repository_actions
      if node['platform_family'] == 'debian'
        apt_r = apt_repo_resource
        apt_r.run_action(:remove)
        new_resource.updated_by_last_action(true) if apt_r.updated_by_last_action?
      else
        yr_r = yum_repo_resource
        yr_r.run_action(:delete)
        new_resource.updated_by_last_action(true) if yr_r.updated_by_last_action?
      end
    end

    pkg_r = package 'elasticsearch' do
      options new_resource.package_options
      version new_resource.version
      action :nothing
    end
    pkg_r.run_action(:remove)
    new_resource.updated_by_last_action(true) if pkg_r.updated_by_last_action?
  end

  def install_package_wrapper_action
    found_download_url = determine_download_url(new_resource, node)
    unless found_download_url
      raise 'Could not determine download url for package on this platform'
    end

    filename = found_download_url.split('/').last
    checksum = determine_download_checksum(new_resource, node)
    package_options = new_resource.package_options

    unless checksum
      Chef::Log.warn("No checksum was provided for #{found_download_url}, this may download a new package on every chef run!")
    end

    remote_file_r = remote_file "#{Chef::Config[:file_cache_path]}/#{filename}" do
      source found_download_url
      checksum checksum
      mode '0644'
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

    es_user = find_es_resource(Chef.run_context, :elasticsearch_user, new_resource)
    found_download_url = determine_download_url(new_resource, node)
    unless found_download_url
      raise 'Could not determine download url for tarball on this platform'
    end

    ark_r = ark 'elasticsearch' do
      url   found_download_url
      owner es_user.username
      group es_user.groupname
      version new_resource.version
      has_binaries ['bin/elasticsearch', 'bin/elasticsearch-plugin']
      checksum determine_download_checksum(new_resource, node)
      prefix_root   new_resource.dir
      prefix_home   new_resource.dir

      not_if do
        link   = "#{new_resource.dir}/elasticsearch"
        target = "#{new_resource.dir}/elasticsearch-#{new_resource.version}"
        binary = "#{target}/bin/elasticsearch"

        ::File.directory?(link) && ::File.symlink?(link) && ::File.readlink(link) == target && ::File.exist?(binary)
      end
      action :nothing
    end
    ark_r.run_action(:install)
    new_resource.updated_by_last_action(true) if ark_r.updated_by_last_action?

    # destroy the sample config directory for tarball installs, or it will
    # take precedence beyond the default stuff in /etc/elasticsearch and within
    # /etc/sysconfig or /etc/default
    sample_r = directory "#{new_resource.dir}/elasticsearch/config" do
      action :nothing
      recursive true
    end
    sample_r.run_action(:delete)
    new_resource.updated_by_last_action(true) if sample_r.updated_by_last_action?
  end

  def remove_tarball_wrapper_action
    # remove the symlink to this version
    link_r = link "#{new_resource.dir}/elasticsearch" do
      only_if do
        link   = "#{new_resource.dir}/elasticsearch"
        target = "#{new_resource.dir}/elasticsearch-#{new_resource.version}"

        ::File.directory?(link) && ::File.symlink?(link) && ::File.readlink(link) == target
      end
      action :nothing
    end
    link_r.run_action(:delete)
    new_resource.updated_by_last_action(true) if link_r.updated_by_last_action?

    # remove the specific version
    d_r = directory "#{new_resource.dir}/elasticsearch-#{new_resource.version}" do
      recursive true
      action :nothing
    end
    d_r.run_action(:delete)
    new_resource.updated_by_last_action(true) if d_r.updated_by_last_action?
  end

  def yum_repo_resource
    yum_repository 'elastic-6.x' do
      baseurl 'https://artifacts.elastic.co/packages/6.x/yum'
      gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
      action :nothing # :add, remove
    end
  end

  def apt_repo_resource
    apt_repository 'elastic-6.x' do
      uri 'https://artifacts.elastic.co/packages/6.x/apt'
      key 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
      components ['main']
      distribution 'stable'
      action :nothing # :create, :delete
    end
  end
end
