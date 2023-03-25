# elasticsearch_user

This custom resource is used to create and manage Elasticsearch users and groups.
Properties

## Properties

The following table provides an overview of the available properties for the elasticsearch_user resource:

| Property    | Type              | Description                                                            |
|-------------|-------------------|------------------------------------------------------------------------|
| `username`  | String            | The username for the Elasticsearch user. (name property)               |
| `groupname` | String            | The group name for the Elasticsearch user. Default is `elasticsearch`. |
| `shell`     | String            | The shell for the Elasticsearch user. Default is `/bin/false`.         |
| `uid`       | [String, Integer] | The user ID for the Elasticsearch user.                                |
| `gid`       | [String, Integer] | The group ID for the Elasticsearch user.                               |

## Examples

### Create a user

The following example creates a user named `elasticsearch`:

```ruby
elasticsearch_user 'elasticsearch'
```

### Create a user with a custom group, shell, and UID

The following example creates a user named `elasticsearch` with a custom group, shell, and UID:

```ruby
elasticsearch_user 'myuser' do
  groupname 'mygroup'
  shell '/bin/bash'
  uid 1234
end
```
