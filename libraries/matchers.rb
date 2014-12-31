# encoding: UTF-8
if defined?(ChefSpec)
  def create_elasticsearch_user(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(
    :elasticsearch_user,
    :create,
    resource_name)
  end
end
