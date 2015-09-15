require 'poise'

class Chef
  # Chef Resource for installing or removing Elasticsearch from package or source
  class Resource::ElasticsearchInstall < Resource
    include Poise
    provides :elasticsearch_install

    actions(:install, :remove)
    default_action :install

    attribute(:type, kind_of: Symbol, :equal_to => [:tarball, :package], default: :tarball)
    attribute(:version, kind_of: String, default: '1.7.2')

    # attributes used by the package-flavor provider
    attribute(:package_url, kind_of: String, default: nil)
    attribute(:package_checksum, kind_of: String, default: nil)
    attribute(:package_options, kind_of: String, default: nil)

    # attributes used by the tarball-flavor provider
    attribute(:tarball_url, kind_of: String, default: lazy {  "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-#{version}.tar.gz" } )
    attribute(:tarball_checksum, kind_of: String, default: '6f81935e270c403681e120ec4395c28b2ddc87e659ff7784608b86beb5223dd2')
    attribute(:dir, kind_of: String, default: nil)
    attribute(:owner, kind_of: String, default: 'elasticsearch')
    attribute(:group, kind_of: String, default: 'elasticsearch')
  end
end
