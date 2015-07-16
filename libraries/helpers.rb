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

    def get_tarball_home_dir(new_resource, node)
      new_resource.dir || node.ark[:prefix_home]
    end

    def get_tarball_root_dir(new_resource, node)
      new_resource.dir || node.ark[:prefix_root]
    end

    # This method takes a hash, but will convert to mash
    def print_value(data, key, options={})
      separator = options[:separator] || ': '

      final_value = format_value(find_value(data, key))

      # track what we've returned in state var
      unless final_value.nil?
        data[:_seen][key] = true
      end

      # keyseparatorexisting_value\n
      [key, separator, final_value, "\n"].join unless final_value.nil?
    end

    # given a hash and a key, get a value out or return nil
    # -- and check for symbols
    def find_value(data, key)
      data[key] unless data[key].nil?
    end

    def format_value(value)
      unless value.nil?
        if value.is_a?(Array)
          value.join(',').to_s
        elsif value.respond_to?(:empty?) && value.empty?
          nil # anything that answers to empty? should be nil again
        else
          value.to_s
        end
      end
    end

  end
end
