# ChefSpec is a tool to unit test cookbooks in conjunction with rspec
# Learn more on the README or at https://github.com/sethvargo/chefspec.
if defined?(ChefSpec)
  ChefSpec.define_matcher(:elasticsearch_configure)
  ChefSpec.define_matcher(:elasticsearch_install)
  ChefSpec.define_matcher(:elasticsearch_plugin)
  ChefSpec.define_matcher(:elasticsearch_service)
  ChefSpec.define_matcher(:elasticsearch_user)

  def create_elasticsearch_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_user, :create, resource_name)
  end

  def remove_elasticsearch_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_user, :remove, resource_name)
  end

  def install_elasticsearch(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_install, :install, resource_name)
  end

  def remove_elasticsearch(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_install, :remove, resource_name)
  end

  def manage_elasticsearch_configure(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_configure, :manage, resource_name)
  end

  def remove_elasticsearch_configure(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_configure, :remove, resource_name)
  end

  def configure_elasticsearch_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_service, :configure, resource_name)
  end

  def remove_elasticsearch_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_service, :remove, resource_name)
  end

  def enable_elasticsearch_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_service, :enable, resource_name)
  end

  def disable_elasticsearch_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_service, :disable, resource_name)
  end

  def start_elasticsearch_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_service, :start, resource_name)
  end

  def stop_elasticsearch_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_service, :stop, resource_name)
  end

  def restart_elasticsearch_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_service, :restart, resource_name)
  end

  def status_elasticsearch_service(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_service, :status, resource_name)
  end

  def install_elasticsearch_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_plugin, :install, resource_name)
  end

  def remove_elasticsearch_plugin(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:elasticsearch_plugin, :remove, resource_name)
  end
end
