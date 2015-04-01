module ElasticsearchCookbook
  module Helpers

    def get_package_url(new_resource, node)
      # short circuit if URL is provided
      return new_resource.package_url if new_resource.package_url

      case node['platform_family']
      when 'debian'
        "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-#{new_resource.version}.deb"
      when 'rhel'
        "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-#{new_resource.version}.noarch.rpm"
      end
    end

    def get_package_checksum(new_resource, node)
      return new_resource.package_checksum if new_resource.package_checksum

      case node['platform_family']
      when 'debian'
        '15a02a2bea74da2330bb78718efb3a8f83a2b2e040a6ee859e100a6556981f36'
      when 'rhel'
        'b72a9fb9a2c0471e8fe1a35373cdcfe39d29e72b7281bfccbdc32d03ee0eff70'
      end
    end

    def get_source_home_dir(new_resource, node)
      new_resource.dir || node.ark[:prefix_home]
    end

    def get_source_root_dir(new_resource, node)
      new_resource.dir || node.ark[:prefix_root]
    end
  end
end
