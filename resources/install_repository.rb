unified_mode true
use 'partial/_common'
# use 'partial/_repository'


property :download_url,
        String,
        default: lazy { default_download_url(new_resource.version) }

property :download_checksum,
        String,
        default: lazy { default_download_checksum(new_resource.version) }

include ElasticsearchCookbook::Helpers

action :install do
  major_version = new_resource.version.split('.')[0]

  es_user = find_es_resource(Chef.run_context, :elasticsearch_user, new_resource)

  unless es_user && es_user.username == 'elasticsearch' && es_user.groupname == 'elasticsearch'
    raise 'Custom usernames/group names is not supported in Elasticsearch 6+ repository installation'
  end

  if new_resource.enable_repository_actions
    if platform_family?('debian')
      apt_repository "elastic-#{major_version}.x" do
        uri 'https://artifacts.elastic.co/packages/7.x/apt'
        key 'elasticsearch.asc'
        cookbook 'elasticsearch'
        components ['main']
        distribution 'stable'
      end
    else
      yum_repository "elastic-#{major_version}.x" do
        baseurl "https://artifacts.elastic.co/packages/#{major_version}.x/yum"
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
end

action :remove do
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
end

action_class do
  include ElasticsearchCookbook::Helpers
end
