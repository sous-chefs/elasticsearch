# `elasticsearch_install`

The install_repository.rb class is part of the Elasticsearch Cookbook and is responsible for managing the installation and removal of Elasticsearch repositories.

It includes helper methods from the `ElasticsearchCookbook::Helpers` module and utilizes partials `_common.rb` and `_repository.rb` for defining properties related to Elasticsearch instances and repository options.

## Properties

The following table provides an overview of the available properties for the install resource, including properties inherited from the included partials:

| Filename                 | Property                    | Description                                                                                                                |
|--------------------------|-----------------------------|----------------------------------------------------------------------------------------------------------------------------|
| `install.rb`             | `type`                      | Specifies the installation type for Elasticsearch. Accepts `package`, `tarball`, or `repository`. Default is `repository`. |
| `partial/_common.rb`     | `instance_name`             | The name of the Elasticsearch instance.                                                                                    |
|                          | `version`                   | The version of Elasticsearch to be installed.                                                                              |
|                          | `package_options`           | Specifies additional package options.                                                                                      |
| `partial/_package.rb`    | `download_url`              | `lazy { default_download_url(new_resource.version)` }                                                                      |
|                          | `download_checksum`         | `lazy { default_download_checksum[new_resource.version](checksum_platform)` }                                              |
| `partial/_repository.rb` | `enable_repository_actions` | Determines whether repository actions are enabled. Can be `true` or `false`. Default is `true`.                            |

## Examples

### Example 1: Install Elasticsearch instance with default values

The following example shows how to install an Elasticsearch instance with default values:

```ruby
elasticsearch_install 'elasticsearch'
```

### Example 2: Install Elasticsearch instance with custom values

The following example shows how to install an Elasticsearch instance with custom values:

```ruby
elasticsearch_install 'elasticsearch' do
  type 'repository'
  version '7.16.1'
  instance_name 'my_es_instance'
  action :install
end
