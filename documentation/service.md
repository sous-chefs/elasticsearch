# elasticsearch_service

This custom resource is used to manage the Elasticsearch service.

## Properties

The following table provides an overview of the available properties for the elasticsearch_service resource:

| Property | Type | Description |
|----------|------|-------------|
| `instance_name` | String | The name of the Elasticsearch instance. Default is `elasticsearch`. |
| `service_name` | String | The name of the Elasticsearch service. Default is `elasticsearch`. |
| `args` | String | Additional arguments to pass to the Elasticsearch service. |
| `service_actions` | [Symbol, String, Array] | The actions to take on the Elasticsearch service. Default is `[:enable, :start]`. |

## Examples

### Start the service

The following example starts the Elasticsearch service:

```ruby
elasticsearch_service 'elasticsearch'
```
