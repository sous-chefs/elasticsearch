module ElasticsearchCookbook
  module Helpers

    def determine_version(new_resource, node)
      if new_resource.version
        new_resource.version.to_s
      elsif node['elasticsearch'] && node['elasticsearch']['version']
        node['elasticsearch']['version'].to_s
      else
        raise 'could not determine version of elasticsearch to install'
      end
    end

    def determine_install_type(new_resource, node)
      if new_resource.type
        new_resource.type.to_s
      elsif node['elasticsearch'] && node['elasticsearch']['install_type']
        node['elasticsearch']['install_type'].to_s
      else
        raise 'could not determine how to install elasticsearch (package? tarball?)'
      end
    end

    def determine_download_url(new_resource, node)
      platform_family = node['platform_family']
      install_type = determine_install_type(new_resource, node)
      version = determine_version(new_resource, node)

      url_string = nil
      if new_resource.download_url
        url_string = new_resource.download_url
      elsif install_type.to_s == 'tar' || install_type.to_s == 'tarball'
        url_string = new_resource.tarball_url || node['elasticsearch']['download_urls']['tar']
      elsif install_type.to_s == 'package' && node['elasticsearch']['download_urls'][platform_family]
        url_string = new_resource.package_url || node['elasticsearch']['download_urls'][platform_family]
      end

      if url_string && version
        return format(url_string, version)
      elsif url_string
        return url_string
      end
    end

    def determine_download_checksum(new_resource, node)
      platform_family = node['platform_family']
      install_type = determine_install_type(new_resource, node)
      version = determine_version(new_resource, node)

      if new_resource.download_checksum
        new_resource.download_checksum
      elsif install_type.to_s == 'tar' || install_type.to_s == 'tarball'
        new_resource.tarball_checksum || node['elasticsearch']['checksums'][version]['tar']
      elsif install_type.to_s == 'package' && node['elasticsearch']['checksums'][version] && node['elasticsearch']['checksums'][version][platform_family]
        new_resource.package_checksum || node['elasticsearch']['checksums'][version][platform_family]
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
