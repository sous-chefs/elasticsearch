# elasticsearch-plugin

This custom resource is used to install and remove Elasticsearch plugins.

## Properties

The following table provides an overview of the available properties for the elasticsearch_plugin resource:

| Property      | Type   | Description                                         |
|---------------|--------|-----------------------------------------------------|
| `plugin_name` | String | The name of the plugin to install or remove.        |
| `url`         | String | The URL of the plugin to install.                   |
| `options`     | String | Additional options to pass to the plugin installer. |

## Examples

### Install a plugin

The following example installs the `analysis-icu` plugin:

```ruby
elasticsearch_plugin 'analysis-icu'
```

### Install a plugin from a URL

The following example installs the `analysis-icu` plugin from a URL:

```ruby
elasticsearch_plugin 'analysis-icu' do
  url 'http://mydomain.com/analysis-icu-2.4.0.zip'
end
```
