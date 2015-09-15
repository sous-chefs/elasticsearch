
class Chef
  # Chef Resource for installing or removing Elasticsearch from package or source
  class Resource::ElasticsearchInstall < Chef::Resource::LWRPBase
    resource_name :elasticsearch_install if respond_to?(:resource_name)
    provides :elasticsearch_install

    actions(:install, :remove)
    default_action :install

    # if this version parameter is not set by the caller, we look at
    # `attributes/default.rb` for a default value to use, or we raise
    attribute(:version, kind_of: String, default: nil)

    # we allow a string or symbol for this value
    attribute(:type, kind_of: [Symbol, String],
      :equal_to => ['tarball', 'tar', 'package', :tarball, :tar, :package], default: 'tarball')


    # these use `attributes/default.rb` for default values per platform and install type
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
