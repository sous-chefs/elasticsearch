# elasticsearch_configure

The `elasticsearch_configure` resource is used to manage Elasticsearch configuration files and directories.

It provides a flexible way to configure Elasticsearch instances by allowing you to set various properties and paths for your Elasticsearch instance.

## Properties

The following table describes the properties available for this resource:

| Property                     | Default                            | Example Values                                                |
|------------------------------|------------------------------------|---------------------------------------------------------------|
| `instance_name`              | -                                  | "my_es_instance"                                              |
| `path_home`                  | '/usr/share/elasticsearch'         | "/opt/elasticsearch"                                          |
| `path_conf`                  | '/etc/elasticsearch'               | "/opt/elasticsearch/config"                                   |
| `path_data`                  | '/var/lib/elasticsearch'           | "/opt/elasticsearch/data"                                     |
| `path_logs`                  | '/var/log/elasticsearch'           | "/opt/elasticsearch/logs"                                     |
| `path_pid`                   | '/var/run/elasticsearch'           | "/opt/elasticsearch/pid"                                      |
| `path_plugins`               | '/usr/share/elasticsearch/plugins' | "/opt/elasticsearch/plugins"                                  |
| `path_bin`                   | '/usr/share/elasticsearch/bin'     | "/opt/elasticsearch/bin"                                      |
| `template_elasticsearch_env` | 'elasticsearch.in.sh.erb'          | "custom_elasticsearch.in.sh.erb"                              |
| `cookbook_elasticsearch_env` | 'elasticsearch'                    | "custom_cookbook"                                             |
| `template_jvm_options`       | 'jvm_options.erb'                  | "custom_jvm_options.erb"                                      |
| `cookbook_jvm_options`       | 'elasticsearch'                    | "custom_cookbook"                                             |
| `template_elasticsearch_yml` | 'elasticsearch.yml.erb'            | "custom_elasticsearch.yml.erb"                                |
| `cookbook_elasticsearch_yml` | 'elasticsearch'                    | "custom_cookbook"                                             |
| `template_log4j2_properties` | 'log4j2.properties.erb'            | "custom_log4j2.properties.erb"                                |
| `cookbook_log4j2_properties` | 'elasticsearch'                    | "custom_cookbook"                                             |
| `logging`                    |                                    | { 'logger.level' => 'info' }                                  |
| `java_home`                  | -                                  | "/usr/lib/jvm/java-11-openjdk"                                |
| `memlock_limit`              | 'unlimited'                        | "4096"                                                        |
| `max_map_count`              | '262144'                           | "1048575"                                                     |
| `nofile_limit`               | '65535'                            | "1048576"                                                     |
| `startup_sleep_seconds`      | 5                                  | 10                                                            |
| `restart_on_upgrade`         | false                              | true                                                          |
| `allocated_memory`           | -                                  | "4g", "1024m"                                                 |
| `jvm_options`                | Array with default values          | ["-XX:MaxDirectMemorySize=1g"]                                |
| `default_configuration`      | Hash with default values           | { 'node.name' => 'custom_node_name'}                          |
| `configuration`              | {}                                 | { 'discovery.zen.ping.unicast.hosts' => '["host1", "host2"]'} |

## Examples

### Example 1: Configure Elasticsearch instance with default values

The following example shows how to configure an Elasticsearch instance with default values:

```ruby
elasticsearch_configure 'elasticsearch'
```

### Example 2: Configure Elasticsearch instance with custom values

The following example shows how to configure an Elasticsearch instance with custom values:

```ruby
elasticsearch_configure 'elasticsearch' do
  allocated_memory '2g'
  configuration ({
    'node.name' => 'my_es_instance',
    'discovery.zen.ping.unicast.hosts' => '["host1", "host2"]'
  })
end
```
