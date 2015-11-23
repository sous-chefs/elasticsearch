# Chef Resource for installing or removing Elasticsearch from package or source
class ElasticsearchCookbook::InstallResource < Chef::Resource::LWRPBase
  resource_name :elasticsearch_install
  provides :elasticsearch_install

  actions(:install, :remove)
  default_action :install

  # this is what helps the various resources find each other
  attribute(:instance_name, kind_of: String, default: nil)

  # if this version parameter is not set by the caller, we look at
  # `attributes/default.rb` for a default value to use, or we raise
  attribute(:version, kind_of: String, default: nil)

  # we allow a string or symbol for this value
  attribute(:type, kind_of: [Symbol],
                   :equal_to => [:tarball, :package], default: :package)

  # these use `attributes/default.rb` for default values per platform and install type
  attribute(:download_url, kind_of: String, default: nil)
  attribute(:download_checksum, kind_of: String, default: nil) # sha256

  # these correspond to :type of install
  attribute(:dir, kind_of: Hash, default: {
              package: '/usr/share',
              tarball: '/usr/local'
            })

  # attributes used by the package-flavor provider
  attribute(:package_options, kind_of: String, default: nil)
end
