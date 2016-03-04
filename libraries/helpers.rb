module ElasticsearchCookbook
  # Helper methods included by various providers and passed to the template engine
  module Helpers
    def find_es_resource(run_context, resource_type, resource)
      resource_name = resource.name
      instance_name = resource.instance_name

      # if we are truly given a specific name to find
      name_match = find_exact_resource(run_context, resource_type, resource_name) rescue nil
      return name_match if name_match

      # first try by instance name attribute
      name_instance = find_instance_name_resource(run_context, resource_type, instance_name) rescue nil
      return name_instance if name_instance

      # otherwise try the defaults
      name_default = find_exact_resource(run_context, resource_type, 'default') rescue nil
      name_elasticsearch = find_exact_resource(run_context, resource_type, 'elasticsearch') rescue nil

      # if we found exactly one default name that matched
      return name_default if name_default && !name_elasticsearch
      return name_elasticsearch if name_elasticsearch && !name_default

      fail "Could not find exactly one #{resource_type} resource, and no specific resource or instance name was given"
    end

    # find exactly the resource name and type, but raise if there's multiple matches
    # see https://github.com/chef/chef/blob/master/lib/chef/resource_collection/resource_set.rb#L80
    def find_exact_resource(run_context, resource_type, resource_name)
      rc = run_context.resource_collection
      result = rc.find(resource_type => resource_name)

      if result && result.is_a?(Array)
        str = ''
        str << "more than one #{resource_type} was found, "
        str << 'you must specify a precise resource name'
        fail str
      end

      return result
    end

    def find_instance_name_resource(run_context, resource_type, instance_name)
      results = []
      rc = run_context.resource_collection

      rc.each do |r|
        next unless r.resource_name == resource_type && r.instance_name == instance_name
        results << r
      end

      if !results.empty? && results.length > 1
        str = ''
        str << "more than one #{resource_type} was found, "
        str << 'you must specify a precise instance name'
        fail str
      elsif !results.empty?
        return results.first
      end

      return nil # falsey
    end

    def determine_version(new_resource, node)
      if new_resource.version
        new_resource.version.to_s
      elsif node['elasticsearch'] && node['elasticsearch']['version']
        node['elasticsearch']['version'].to_s
      else
        fail 'could not determine version of elasticsearch to install'
      end
    end

    def determine_install_type(new_resource, node)
      if new_resource.type
        new_resource.type.to_s
      elsif node['elasticsearch'] && node['elasticsearch']['install_type']
        node['elasticsearch']['install_type'].to_s
      else
        fail 'could not determine how to install elasticsearch (package? tarball?)'
      end
    end

    def determine_download_url(new_resource, node)
      platform_family = node['platform_family']
      install_type = determine_install_type(new_resource, node)
      version = determine_version(new_resource, node)
      newer_url_style = version.to_f >= 2.0

      # v2 and greater has a different set of URLs
      url_hash_key = newer_url_style ? 'download_urls_v2' : 'download_urls'

      url_string = nil
      if new_resource.download_url
        url_string = new_resource.download_url
      elsif install_type.to_s == 'tar' || install_type.to_s == 'tarball'
        url_string = node['elasticsearch'][url_hash_key]['tar']
      elsif install_type.to_s == 'package' && node['elasticsearch'][url_hash_key][platform_family]
        url_string = node['elasticsearch'][url_hash_key][platform_family]
      end

      if url_string && version
        # v2 and greater has two %s entries for version
        return (newer_url_style ? format(url_string, version, version) : format(url_string, version))
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
        node && version &&
          node['elasticsearch'] &&
          node['elasticsearch']['checksums'] &&
          node['elasticsearch']['checksums'][version] &&
          node['elasticsearch']['checksums'][version]['tar']
      elsif install_type.to_s == 'package' && node['elasticsearch']['checksums'][version] && node['elasticsearch']['checksums'][version][platform_family]
        node && version && platform_family &&
          node['elasticsearch'] &&
          node['elasticsearch']['checksums'] &&
          node['elasticsearch']['checksums'][version] &&
          node['elasticsearch']['checksums'][version][platform_family]
      end
    end

    # This method takes a hash, but will convert to mash
    def print_value(data, key, options = {})
      separator = options[:separator] || ': '

      final_value = format_value(find_value(data, key))

      # track what we've returned in state var
      unless final_value.nil?
        data['#_seen'][key] = true
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
      if value.nil?
        nil # just pass through nil
      elsif value.is_a?(Array)
        value.join(',').to_s
      elsif value.respond_to?(:empty?) && value.empty?
        nil # anything that answers to empty? should be nil again
      else
        value.to_s
      end
    end

    # proxy helpers for chef
    def get_configured_proxy
      if Chef::Config['http_proxy'] && !Chef::Config['http_proxy'].empty?
        Chef::Config['http_proxy']
      elsif Chef::Config['https_proxy'] && !Chef::Config['https_proxy'].empty?
        Chef::Config['https_proxy']
      end
    end

    def get_java_proxy_arguments(enabled = true)
      return '' unless enabled

      require 'uri'
      parsed_uri = URI(get_configured_proxy)
      "-DproxyHost=#{parsed_uri.host} -DproxyPort=#{parsed_uri.port}"
    rescue
      ''
    end
  end
end
