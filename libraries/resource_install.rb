require 'poise'

class Chef
  # Chef Resource for installing or removing Elasticsearch from package or source
  class Resource::ElasticsearchInstall < Resource
    include Poise
    provides :elasticsearch_install

    actions(:install, :remove)
    default_action :install

    attribute(:type, kind_of: Symbol, :equal_to => [:tarball, :package], default: :tarball)
    attribute(:version, kind_of: String, default: '1.5.0')

    # attributes used by the package-flavor provider
    attribute(:package_url, kind_of: String, default: nil)
    attribute(:package_checksum, kind_of: String, default: nil)
    attribute(:package_options, kind_of: String, default: nil)

    # attributes used by the tarball-flavor provider
    attribute(:tarball_url, kind_of: String, default: lazy {  "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-#{version}.tar.gz" } )
    attribute(:tarball_checksum, kind_of: String, default: 'acf572c606552bc446cceef3f8e93814a363ba0d215b323a2864682b3abfbe45')
    attribute(:dir, kind_of: String, default: nil)
    attribute(:owner, kind_of: String, default: 'elasticsearch')
    attribute(:group, kind_of: String, default: 'elasticsearch')
  end
end
