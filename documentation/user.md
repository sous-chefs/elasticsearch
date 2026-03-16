# elasticsearch_user

Manages the Elasticsearch system user and group.

## Actions

| Action    | Description                |
|-----------|----------------------------|
| `:create` | Creates the user and group |
| `:remove` | Removes the user and group |

## Properties

| Property        | Type    | Default                | Description                       |
|-----------------|---------|------------------------|-----------------------------------|
| `username`      | String  | name property          | System username                   |
| `groupname`     | String  | lazy { username }      | System group name                 |
| `shell`         | String  | `'/bin/bash'`          | Login shell                       |
| `uid`           | Integer | -                      | User ID                           |
| `gid`           | Integer | -                      | Group ID                          |
| `comment`       | String  | `'Elasticsearch User'` | User comment/GECOS field          |
| `instance_name` | String  | -                      | Used to look up related resources |

## Examples

### Basic usage

```ruby
elasticsearch_user 'elasticsearch'
```

### Custom user and group

```ruby
elasticsearch_user 'myuser' do
  groupname 'mygroup'
  shell '/bin/sh'
  uid 1234
  gid 5678
end
```
