# ChefSpec is a tool to unit test cookbooks in conjunction with rspec
# Learn more on the README or at https://github.com/sethvargo/chefspec. 
if defined?(ChefSpec)
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
end
