include_attribute 'elasticsearch::default'
include_attribute 'elasticsearch::plugins'

kopf = Chef::DataBagItem.load('elasticsearch', 'kopf')[node.chef_environment] rescue {}

default.elasticsearch['pluginslmenezes/elasticsearch-kopf']['version'] = '1.3.8'
