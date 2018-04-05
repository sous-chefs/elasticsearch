# Chef Resource for installing or removing Elasticsearch from package or source
class ElasticsearchCookbook::InstallResource < Chef::Resource::LWRPBase
  resource_name :elasticsearch_install
  provides :elasticsearch_install

  actions(:install, :remove)
  default_action :install

  # this is what helps the various resources find each other
  attribute(:instance_name, kind_of: String)

  # if this version parameter is not set by the caller, we look at
  # `attributes/default.rb` for a default value to use, or we raise
  attribute(:version, kind_of: String, default: '6.2.3')

  # we allow a string or symbol for this value
  attribute(:type, kind_of: String, equal_to: %w(package tarball repository), default: 'repository')

  # these use `attributes/default.rb` for default values per platform and install type
  attribute(:download_url, kind_of: String)
  attribute(:download_checksum, kind_of: String) # sha256

  # where to install?
  attribute(:dir, kind_of: String, default: '/usr/share')

  # attributes used by the package-flavor provider
  attribute(:package_options, kind_of: String)

  # attributes for the repository-option install
  attribute(:enable_repository_actions, kind_of: [TrueClass, FalseClass], default: true)
end
