property :download_url,
        String,
        default: lazy { default_download_url(version) }

property :download_checksum,
        String,
        default: lazy { default_download_checksum(version)[checksum_platform] }
