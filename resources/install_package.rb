include ElasticsearchCookbook::Helpers
unified_mode true
use 'partial/_common'
use 'partial/_package'

action :install do
  remote_file "#{Chef::Config[:file_cache_path]}/#{filename_from_url}" do
    source new_resource.download_url
    checksum new_resource.download_checksum
    mode '0644'
    action :create
  end

  if platform_family?('debian')
    dpkg_package filename_from_url do
      options new_resource.package_options
      source "#{Chef::Config[:file_cache_path]}/#{filename_from_url}"
      action :install
    end
  else
    package filename_from_url do
      options new_resource.package_options
      source "#{Chef::Config[:file_cache_path]}/#{filename_from_url}"
      action :install
    end
  end
end

action :remove do
  package "#{Chef::Config[:file_cache_path]}/#{filename_from_url}" do
    action :remove
  end
end

action_class do
  include ElasticsearchCookbook::Helpers

  def filename_from_url
    new_resource.download_url.split('/').last
  end
end
