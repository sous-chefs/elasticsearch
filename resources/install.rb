unified_mode true
use 'partial/_common'
use 'partial/_package'
use 'partial/_repository'

property :type,
        String,
        equal_to: %w(package tarball repository),
        default: 'repository'

action :install do
  case new_resource.type
  when 'tarball'
    raise 'Tarball method is not currently supported, due to no supporting systemd service'
  when 'package'
    elasticsearch_install_package "ElasticSearch #{new_resource.version}" do
      version new_resource.version
      instance_name new_resource.instance_name
      download_url new_resource.download_url
      download_checksum new_resource.download_checksum
    end
  when 'repository'
    elasticsearch_install_repository "ElasticSearch #{new_resource.version}" do
      version new_resource.version
      instance_name new_resource.instance_name
      enable_repository_actions new_resource.enable_repository_actions
      package_options new_resource.package_options
    end
  else
    raise "#{new_resource.type} is not a valid install type"
  end
end

action :remove do
  case new_resource.type
  when 'package'
    elasticsearch_install_package "ElasticSearch #{new_resource.version}" do
      action :remove
    end
  when 'repository'
    elasticsearch_install_repository "ElasticSearch #{new_resource.version}" do
      action :remove
    end
  else
    raise "#{install_type} is not a valid install type"
  end
end
