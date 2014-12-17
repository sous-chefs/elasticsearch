include_attribute 'elasticsearch::default'
include_attribute 'elasticsearch::plugins'

kopf = Chef::DataBagItem.load('elasticsearch', 'kopf')[node.chef_environment] rescue {}

default.elasticsearch['plugins']['kopf']['version'] = '1.4.0'
