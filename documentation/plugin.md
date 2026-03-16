# elasticsearch_plugin

Installs and removes Elasticsearch plugins.

## Actions

| Action     | Description         |
|------------|---------------------|
| `:install` | Installs the plugin |
| `:remove`  | Removes the plugin  |

## Properties

| Property        | Type   | Default       | Description                                     |
|-----------------|--------|---------------|-------------------------------------------------|
| `plugin_name`   | String | name property | Plugin name or identifier                       |
| `url`           | String | -             | URL to install plugin from (overrides name)     |
| `options`       | String | `''`          | Additional options for the plugin command       |
| `instance_name` | String | -             | Used to look up related elasticsearch resources |

## Examples

### Install a plugin

```ruby
elasticsearch_plugin 'analysis-icu'
```

### Install a plugin from a URL

```ruby
elasticsearch_plugin 'analysis-icu' do
  url 'http://mydomain.com/analysis-icu-2.4.0.zip'
end
```

### Install with restart notification

```ruby
elasticsearch_plugin 'analysis-icu' do
  notifies :restart, 'elasticsearch_service[elasticsearch]', :delayed
end
```
