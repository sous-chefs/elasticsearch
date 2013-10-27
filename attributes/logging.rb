default.elasticsearch[:logging]['action'] = 'DEBUG'
default.elasticsearch[:logging]['com.amazonaws'] = 'WARN'
default.elasticsearch[:logging]['index.search.slowlog'] = 'TRACE, index_search_slow_log_file'
default.elasticsearch[:logging]['index.indexing.slowlog'] = 'TRACE, index_indexing_slow_log_file'

# we use a different key here so that we don't try to add these in the template for loop
# since these are really not ES specific logging options, they are log4j options.
default.elasticsearch[:logger][:maxBackup] = 10
default.elasticsearch[:logger][:maxSize] = "10MB"
default.elasticsearch[:logger][:useFileSize] = false
default.elasticsearch[:logger][:datePattern] = "'.'yyyy-MM-dd"

# --------------------------------------------
# NOTE: Setting the attributes for logging.yml
# --------------------------------------------
#
# The template iterates over all values set in the `node.elasticsearch.logging`
# namespace and prints all settings which have been configured;
# this file only configures the minimal default set.
#
# To configure logging, simply set the corresponding attribute, eg.:
#
#     node.elasticsearch.logging['discovery'] = 'TRACE'
#
# Use the same notation for deeply nested attributes:
#
#     node.elasticsearch.logging['index.search.slowlog'] = 'DEBUG, index_search_slow_log_file'
#
