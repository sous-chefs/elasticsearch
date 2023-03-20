# install_repository

The install_repository.rb class is part of the Elasticsearch Cookbook and is responsible for managing the installation and removal of Elasticsearch repositories. It includes helper methods from the ElasticsearchCookbook::Helpers module and utilizes partials _common.rb and_repository.rb for defining properties related to Elasticsearch instances and repository options.

## Notes

Custom usernames and group names are not supported in Elasticsearch 6+ repository installations. The enable_repository_actions property allows you to control whether repository-related actions, such as adding or removing repositories, are enabled.

## Properties

The following table provides an overview of the available properties for the install_repository.rb class, including properties inherited from the included partials:

| Filename                 | Properties                  | Default  | Example Values                               |
|--------------------------|-----------------------------|----------|----------------------------------------------|
| `partial/_common.rb`     | `instance_name`             | -        | "elasticsearch", "my_elasticsearch_instance" |
|                          | `version`                   | "7.17.9" | "7.17.9", "8.0.0"                            |
|                          | `package_options`           | -        | "--force-yes", "--no-install-recommends"     |
| `partial/_repository.rb` | `enable_repository_actions` | true     | true, false                                  |

## Examples

```ruby
elasticsearch_install_repository 'elastic_repo' do
  instance_name 'my_elasticsearch_instance'
  version '8.0.0'
  package_options '--force-yes --no-install-recommends'
  enable_repository_actions true
end
```

This example installs an Elasticsearch repository for version '8.0.0' with package options to force the installation and avoid installing recommended packages. The enable_repository_actions property is set to true, allowing repository-related actions to be performed.
