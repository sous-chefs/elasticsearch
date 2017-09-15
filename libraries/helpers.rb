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

    def determine_download_url(new_resource, node)
      platform_family = node['platform_family']

      url_string = nil
      if new_resource.download_url
        url_string = new_resource.download_url
      elsif new_resource.type == 'tarball'
        url_string = node['elasticsearch']['download_urls']['tarball']
      elsif new_resource.type == 'package' && node['elasticsearch']['download_urls'][platform_family]
        url_string = node['elasticsearch']['download_urls'][platform_family]
      end

      if url_string && new_resource.version
        return format(url_string, new_resource.version)
      elsif url_string
        return url_string
      end
    end

    def determine_download_checksum(new_resource, node)
      platform_family = node['platform_family']

      # for the sake of finding correct attribute data, use rhel for amazon too
      # See https://github.com/elastic/cookbook-elasticsearch/issues/609
      platform_family = 'rhel' if platform_family == 'amazon'

      install_type = new_resource.type
      version = new_resource.version

      if new_resource.download_checksum
        new_resource.download_checksum
      elsif install_type == 'tarball'
        node && version &&
          node['elasticsearch'] &&
          node['elasticsearch']['checksums'] &&
          node['elasticsearch']['checksums'][version] &&
          node['elasticsearch']['checksums'][version]['tarball']
      elsif install_type == 'package' && node['elasticsearch']['checksums'][version] && node['elasticsearch']['checksums'][version][platform_family]
        node && version && platform_family &&
          node['elasticsearch'] &&
          node['elasticsearch']['checksums'] &&
          node['elasticsearch']['checksums'][version] &&
          node['elasticsearch']['checksums'][version][platform_family]
      end
    end

    # proxy helper for chef sets JVM 8 proxy options
    def get_java_proxy_arguments(enabled = true)
      return '' unless enabled
      require 'uri'
      output = ''

      if Chef::Config[:http_proxy] && !Chef::Config[:http_proxy].empty?
        parsed_uri = URI(Chef::Config[:http_proxy])
        output += "-Dhttp.proxyHost=#{parsed_uri.host} -Dhttp.proxyPort=#{parsed_uri.port} "
      end

      if Chef::Config[:https_proxy] && !Chef::Config[:https_proxy].empty?
        parsed_uri = URI(Chef::Config[:https_proxy])
        output += "-Dhttps.proxyHost=#{parsed_uri.host} -Dhttps.proxyPort=#{parsed_uri.port} "
      end

      output
    rescue
      ''
    end
  end

  class HashAndMashBlender
    attr_accessor :target
    def initialize(hash_or_mash_or_whatever)
      self.target = hash_or_mash_or_whatever
    end

    def to_hash
      target.each_with_object({}) do |(k, v), hsh|
        hsh[k] =
          if v.respond_to?(:to_hash)
            self.class.new(v).to_hash
          elsif v.respond_to?(:to_a)
            v.to_a
          else
            v
          end
      end
    end
  end
end
