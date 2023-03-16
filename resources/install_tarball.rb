unified_mode true
use 'partial/_common'
use 'partial/_tarball'
include ElasticsearchCookbook::Helpers

action :install do
  found_download_url = determine_download_url(new_resource, node)

  raise 'Could not determine download url for tarball on this platform' unless found_download_url

  ark 'elasticsearch' do
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
    action :install
  end

  # Delete the sample config directory for tarball installs, or it will
  # take precedence beyond the default stuff in /etc/elasticsearch and within
  # /etc/sysconfig or /etc/default
  directory "#{new_resource.dir}/elasticsearch/config" do
    action :delete
    recursive true
  end
end

action :remove do
  def remove_tarball_wrapper_action
    link "#{new_resource.dir}/elasticsearch" do
      only_if do
        link   = "#{new_resource.dir}/elasticsearch"
        target = "#{new_resource.dir}/elasticsearch-#{new_resource.version}"

        ::File.directory?(link) && ::File.symlink?(link) && ::File.readlink(link) == target
      end
      action :delete
    end

    directory "#{new_resource.dir}/elasticsearch-#{new_resource.version}" do
      recursive true
      action :delete
    end
  end
end
