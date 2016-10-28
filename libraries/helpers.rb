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

      raise "Could not find exactly one #{resource_type} resource, and no specific resource or instance name was given"
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
        raise str
      end

      result
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
        raise str
      elsif !results.empty?
        return results.first
      end

      nil # falsey
    end

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
        url_string = node['elasticsearch']['download_urls']['tar']
      elsif install_type.to_s == 'package' && node['elasticsearch']['download_urls'][platform_family]
        url_string = node['elasticsearch']['download_urls'][platform_family]
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
