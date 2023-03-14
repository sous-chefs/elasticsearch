include ElasticsearchCookbook::Helpers
unified_mode true

# this is what helps the various resources find each other
property :instance_name,
        String

property :version,
        String,
        default: '7.17.9'

property :type,
        String,
        equal_to: %w(package tarball repository),
        default: 'repository'

# these use `attributes/default.rb` for default values per platform and install type
property :download_url,
        String
property :download_checksum,
        String

property :dir,
        String,
        default: '/usr/share'

# attributes used by the package-flavor provider
property :package_options,
        String

# attributes for the repository-option install
property :enable_repository_actions,
        [true, false],
        default: true

action :install do
  case new_resource.type
  when 'tarball'
    install_tarball_wrapper_action
  when 'package'
    install_package_wrapper_action
  when 'repository'

    es_user = find_es_resource(Chef.run_context, :elasticsearch_user, new_resource)
    unless es_user && es_user.username == 'elasticsearch' && es_user.groupname == 'elasticsearch'
      raise 'Custom usernames/group names is not supported in Elasticsearch 6+ repository installation'
    end

    if new_resource.enable_repository_actions
      if platform_family?('debian')
        apt_repository "elastic-#{new_resource.version}.x" do
          uri 'https://artifacts.elastic.co/packages/7.x/apt'
          key 'elasticsearch.asc'
          cookbook 'elasticsearch'
          components ['main']
          distribution 'stable'
        end
      else
        yum_repository "elastic-#{new_resource.version}.x" do
          baseurl "https://artifacts.elastic.co/packages/#{new_resource.version}.x/yum"
          gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
          action :create
        end
      end
    end

    package 'elasticsearch' do
      options new_resource.package_options
      version new_resource.version
      action :install
    end
  else
    raise "#{install_type} is not a valid install type"
  end
end

action :remove do
  case new_resource.type
  when 'tarball'

    link "#{new_resource.dir}/elasticsearch" do
      only_if do
        link   = "#{new_resource.dir}/elasticsearch"
        target = "#{new_resource.dir}/elasticsearch-#{new_resource.version}"

        ::File.directory?(link) && ::File.symlink?(link) && ::File.readlink(link) == target
      end
      action :delete
    end

    # remove the specific version
    directory "#{new_resource.dir}/elasticsearch-#{new_resource.version}" do
      recursive true
      action :delete
    end
  when 'package'

    remove_package_wrapper_action
  when 'repository'

    if new_resource.enable_repository_actions
      if platform_family?('debian')
        apt_repository "elastic-#{new_resource.version}.x" do
          action :remove
        end
      else
        yum_repository "elastic-#{new_resource.version}.x" do
          action :remove
        end
      end
    end

    package 'elasticsearch' do
      options new_resource.package_options
      version new_resource.version
      action :remove
    end
  else
    raise "#{install_type} is not a valid install type"
  end
end

action_class do
  def install_package_wrapper_action
    es_user = find_es_resource(Chef.run_context, :elasticsearch_user, new_resource)

    unless es_user && es_user.username == 'elasticsearch' && es_user.groupname == 'elasticsearch'
      raise 'Custom usernames/group names is not supported in Elasticsearch 6+ package installation'
    end

    found_download_url = determine_download_url(new_resource, node)

    raise 'Could not determine download url for package on this platform' unless found_download_url

    filename = found_download_url.split('/').last
    checksum = determine_download_checksum(new_resource, node)
    package_options = new_resource.package_options

    unless checksum
      Chef::Log.warn("No checksum was provided for #{found_download_url}, this may download a new package on every chef run!")
    end

    remote_file "#{Chef::Config[:file_cache_path]}/#{filename}" do
      source found_download_url
      checksum checksum
      mode '0644'
      action :create
    end

    if platform_family?('debian')
      dpkg_package "#{Chef::Config[:file_cache_path]}/#{filename}" do
        options package_options
        action :install
      end
    else
      package "#{Chef::Config[:file_cache_path]}/#{filename}" do
        options package_options
        action :install
      end
    end
  end

  def remove_package_wrapper_action
    package_url = determine_download_url(new_resource, node)

    filename = package_url.split('/').last

    if platform_family?('debian')
      dpkg_package "#{Chef::Config[:file_cache_path]}/#{filename}" do
        action :temove
      end
    else
      package "#{Chef::Config[:file_cache_path]}/#{filename}" do
        action :temove
      end
    end
  end

  def install_tarball_wrapper_action
    es_user = find_es_resource(Chef.run_context, :elasticsearch_user, new_resource)
    found_download_url = determine_download_url(new_resource, node)

    raise 'Could not determine download url for tarball on this platform' unless found_download_url

    ark 'elasticsearch' do
      url   found_download_url
      owner es_user.username
      group es_user.groupname
      version new_resource.version
      has_binaries ['bin/elasticsearch', 'bin/elasticsearch-cli', 'bin/elasticsearch-env', 'bin/elasticsearch-plugin']
      checksum determine_download_checksum(new_resource, node)
      prefix_root   new_resource.dir
      prefix_home   new_resource.dir

      not_if do
        link   = "#{new_resource.dir}/elasticsearch"
        target = "#{new_resource.dir}/elasticsearch-#{new_resource.version}"
        binary = "#{target}/bin/elasticsearch"

        ::File.directory?(link) && ::File.symlink?(link) && ::File.readlink(link) == target && ::File.exist?(binary)
      end
      action :install
    end

    # Delete the sample config directory for tarball installs, or it will
    # take precedence beyond the default stuff in /etc/elasticsearch and within
    # /etc/sysconfig or /etc/default
    directory "#{new_resource.dir}/elasticsearch/config" do
      action :delete
      recursive true
    end
  end
end
