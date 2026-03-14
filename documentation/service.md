# elasticsearch_service

Manages the Elasticsearch systemd service unit.

## Actions

| Action       | Description                              |
|--------------|------------------------------------------|
| `:configure` | Creates systemd unit and manages service |
| `:enable`    | Enables the service                      |
| `:disable`   | Disables the service                     |
| `:start`     | Starts the service                       |
| `:stop`      | Stops the service                        |
| `:restart`   | Restarts the service                     |
| `:status`    | Checks service status                    |

## Properties

| Property          | Type                  | Default             | Description                                                                                                  |
|-------------------|-----------------------|---------------------|--------------------------------------------------------------------------------------------------------------|
| `service_name`    | String                | name property       | The systemd service unit name                                                                                |
| `instance_name`   | String                | -                   | Used to look up related elasticsearch resources                                                              |
| `service_actions` | Symbol, String, Array | `[:enable, :start]` | Actions to perform on the service                                                                            |
| `restart_policy`  | String                | `''`                | Systemd restart policy: `no`, `always`, `on-success`, `on-failure`, `on-abnormal`, `on-abort`, `on-watchdog` |
| `restart_sec`     | Integer, String       | -                   | Time to sleep before restarting (seconds or time span like `5min 20s`)                                       |

## Examples

### Basic usage

```ruby
elasticsearch_service 'elasticsearch'
```

### With restart policy

```ruby
elasticsearch_service 'elasticsearch' do
  restart_policy 'on-failure'
  restart_sec 30
end
```
