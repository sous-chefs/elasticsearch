# frozen_string_literal: true

include ElasticsearchCookbook::Helpers
include ElasticsearchCookbook::VersionHelpers

property :instance_name,
          String

property :version,
        String,
        default: '8.19.12'

property :package_options,
        String
