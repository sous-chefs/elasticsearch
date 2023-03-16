property :download_url,
        String,
        default: lazy { default_download_url(new_resource.version) }

property :download_checksum,
        String,
        default: lazy { default_download_checksum(new_resource.version)[checksum_platform] }

property :package_options,
        String
