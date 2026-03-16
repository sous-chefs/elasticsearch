# frozen_string_literal: true

provides :elasticsearch_install_package
unified_mode true

include ElasticsearchCookbook::Helpers

use 'partial/_common'
use 'partial/_package'

action :install do
  remote_file package_filename do
    source new_resource.download_url
    checksum new_resource.download_checksum
    mode '0644'
    action :create
  end

  if platform_family?('debian')
    dpkg_package filename_from_url do
      options new_resource.package_options
      source package_filename
      action :install
    end
  else
    package filename_from_url do
      options new_resource.package_options
      source package_filename
      action :install
    end
  end
end

action :remove do
  package package_filename do
    action :remove
  end
end

action_class do
  include ElasticsearchCookbook::Helpers

  def package_filename
    "#{Chef::Config[:file_cache_path]}/#{filename_from_url}"
  end

  def filename_from_url
    new_resource.download_url.split('/').last
  end
end
