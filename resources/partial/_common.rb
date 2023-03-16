include ElasticsearchCookbook::Helpers
include ElasticsearchCookbook::VersionHelpers

property :instance_name,
          String

property :version,
        String,
        default: '7.17.9'

property :package_options,
        String
