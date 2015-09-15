require 'poise'

class Chef
  # Chef Resource for installing or removing Elasticsearch from package or source
  class Resource::ElasticsearchInstall < Resource
    include Poise
    resource_name :elasticsearch_install if respond_to?(:resource_name)
    provides :elasticsearch_install

    actions(:install, :remove)
    default_action :install

    attribute(:type, kind_of: Symbol, :equal_to => [:tarball, :tar, :package], default: :tar)
    attribute(:version, kind_of: String, default: '1.7.2')

    attribute(:download_url, kind_of: String, default: nil)
    attribute(:download_checksum, kind_of: String, default: nil) # sha256

    # attributes used by the package-flavor provider
    attribute(:package_options, kind_of: String, default: nil)

    # attributes used by the tarball-flavor provider
    attribute(:dir, kind_of: String, default: nil)
    attribute(:owner, kind_of: String, default: 'elasticsearch')
    attribute(:group, kind_of: String, default: 'elasticsearch')

    # deprecated, use download_url and download_checksum
    attribute(:package_url, kind_of: String, default: nil)
    attribute(:package_checksum, kind_of: String, default: nil) # sha256
    attribute(:tarball_url, kind_of: String, default: nil)
    attribute(:tarball_checksum, kind_of: String, default: nil) # sha256
  end
end
