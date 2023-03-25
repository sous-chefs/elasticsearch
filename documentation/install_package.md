
# install_package

The install_package manages the installation and removal of Elasticsearch packages.

It includes helper methods from the `ElasticsearchCookbook::Helpers` module and utilizes partials `_common.rb` and `_package.rb` for defining properties related to Elasticsearch instances and package options.

## Properties

The following table provides an overview of the available properties for the install_package.rb class, including properties inherited from the included partials:

| Filename              | Properties          | Default                                                                       |
|-----------------------|---------------------|-------------------------------------------------------------------------------|
| `partial/_common.rb`  | `instance_name`     | -                                                                             |
|                       | `version`           | "7.17.9"                                                                      |
|                       | `package_options`   | -                                                                             |
| `partial/_package.rb` | `download_url`      | `lazy { default_download_url(new_resource.version)` }                         |
|                       | `download_checksum` | `lazy { default_download_checksum[new_resource.version](checksum_platform)` } |

## Notes

The `download_url` and `download_checksum` properties have default values that are generated based on the specified Elasticsearch version. If you want to use custom values, you can override the defaults by providing your own values.

## Examples

```ruby
elasticsearch_install 'elastic' do
  instance_name 'my_elasticsearch_instance'
  version '8.0.0'
  download_url 'https://example.com/elasticsearch-8.0.0.rpm'
  download_checksum 'c2d5e5a5e42a5ac5e5c5e5a5a5c2d5e5'
  package_options '--force-yes --no-install-recommends'
end
```

This example installs an Elasticsearch instance with the name 'my_elasticsearch_instance', using version '8.0.0'. The download URL points to an RPM file, and the specified checksum is used for validation. Package options are provided to force the installation and avoid installing recommended packages.
