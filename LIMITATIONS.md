# Limitations

## Package Availability

Elasticsearch is distributed as pre-built packages (DEB, RPM) and tar.gz archives.
There is no source/compiled installation option — it is a Java application shipped with a bundled JDK.

Repository URL pattern: `https://artifacts.elastic.co/packages/{major}.x/{apt|yum}`
GPG key: `https://artifacts.elastic.co/GPG-KEY-elasticsearch`

### APT (Debian/Ubuntu)

- Ubuntu 20.04: ES 7.x, 8.x (amd64, arm64)
- Ubuntu 22.04: ES 7.x, 8.x (amd64, arm64)
- Ubuntu 24.04: ES 8.x (amd64, arm64)
- Debian 11: ES 7.x, 8.x (amd64, arm64)
- Debian 12: ES 7.x, 8.x (amd64, arm64)
- Debian 13: ES 8.x (amd64, arm64)

### DNF/YUM (RHEL family)

- RHEL 8 / AlmaLinux 8 / Rocky Linux 8 / Oracle Linux 8: ES 7.x, 8.x (x86_64, aarch64)
- RHEL 9 / AlmaLinux 9 / Rocky Linux 9 / Oracle Linux 9: ES 7.x, 8.x (x86_64, aarch64)
- AlmaLinux 10 / Rocky Linux 10 / CentOS Stream 10: ES 8.x (x86_64, aarch64)
- CentOS Stream 9: ES 7.x, 8.x (x86_64, aarch64)
- Amazon Linux 2023: ES 8.x (x86_64, aarch64)
- Fedora (latest): ES 8.x (x86_64, aarch64)

### Zypper (SUSE)

- openSUSE Leap 15: ES 7.x, 8.x (x86_64, aarch64) — RPM packages via YUM repository

## Architecture Limitations

- aarch64/arm64 packages available since ES 7.12+
- All platforms support both amd64/x86_64 and arm64/aarch64

## Source/Compiled Installation

Not applicable. Elasticsearch is a Java application distributed as pre-built packages with a bundled JDK.
The cookbook's tarball install type is currently disabled due to lack of systemd service support.

## Cookbook vs Vendor Support

### metadata.rb `supports` declarations

The cookbook declares: `amazon`, `centos`, `debian`, `fedora`, `redhat`, `ubuntu`

### Missing from metadata.rb

These platforms are tested in `kitchen.dokken.yml` but not declared in `metadata.rb`:

- `almalinux` — RHEL derivative, works via `platform_family?('rhel')`
- `rockylinux` — RHEL derivative, works via `platform_family?('rhel')`
- `oraclelinux` — RHEL derivative, works via `platform_family?('rhel')`
- `opensuse` — uses YUM/Zypper repository; supported by Elastic

### Not supported by this cookbook

- SUSE Linux Enterprise Server (SLES) — no `zypper_repository` resource in the cookbook
- Windows, macOS — not applicable for this cookbook

## Known Issues

- Default version in `_common.rb` partial is `7.17.9`; ES 8.x is the current major release
- The `versions.rb` checksum library only covers ES 6.x–8.6.2; newer 8.x versions require the repository install type
- Tarball install type raises an error — no systemd service template for tarball installs

## Disabled Platforms

### Debian 13 (Trixie)

Elastic's 7.x APT repository GPG key uses SHA1 signatures. Debian 13 rejects SHA1 as insecure
(since 2026-02-01), causing `apt-get update` to fail with "repository is not signed". This is an
upstream Elastic issue — their GPG key needs to be re-signed with a stronger hash algorithm.
The repository install type will fail on Debian 13 with Elasticsearch 7.x.

### Amazon Linux 2023

The `dokken/amazonlinux-2023` container image is missing `/usr/lib/systemd/systemd-sysv-install`,
which `systemctl enable` invokes when synchronizing SysV service state. This causes the
`service[elasticsearch] action enable` to fail. This is a Dokken container image issue, not a
cookbook bug. Amazon Linux 2023 may work with Vagrant or bare-metal provisioners.
