# Change Log

## [v4.0.0](https://github.com/elastic/cookbook-elasticsearch/tree/v4.0.0) (2018-03-25)
- Default to 6.0.0 and add sha256 checksums, drop old 5.x hashes
- Point to 6.x yum repo
- Introduce 6.0.0's JVM options for ES 6
- ES_JVM_OPTIONS is no longer supported in v6.0.0
- Correct tests with x-pack installation
- Remove test for config entry that is no longer valid
- Remove path.conf reference after testing
- Stop testing on Ubuntu 12.04 and earlier

## [v3.4.5](https://github.com/elastic/cookbook-elasticsearch/tree/v3.4.5) (2018-03-25)
- Add documentation for Java "trust anchors" problem (#646)
- Add hashes for 5.6.8 (#649)

## [v3.4.4](https://github.com/elastic/cookbook-elasticsearch/tree/v3.4.4) (2018-02-01)
- Add hashes for ES 5.6.6 (#638) and ES 5.6.7 (#640)

## [v3.4.3](https://github.com/elastic/cookbook-elasticsearch/tree/v3.4.3) (2018-01-03)
- Add hashes for ES 5.6.5 (#632)

## [v3.4.2](https://github.com/elastic/cookbook-elasticsearch/tree/v3.4.2) (2017-12-03)
- Add hashes for ES 5.6.4 (#622)

## [v3.4.1](https://github.com/elastic/cookbook-elasticsearch/tree/v3.4.1) (2017-10-18)
- Add hashes for ES 5.6.3 (#616)

## [v3.4.0](https://github.com/elastic/cookbook-elasticsearch/tree/v3.4.0) (2017-09-28)
- Add hashes for ES 5.6.1 and 5.6.2 (#613)
- Add the latest init scripts from .deb, .rpm, and systemd

## [v3.3.1](https://github.com/elastic/cookbook-elasticsearch/tree/v3.3.1) (2017-09-15)
- Add hashes for ES 5.6.0 and 5.5.3 (#610)
- Workaround for support 'amazon' platform_family (#609)

## [v3.3.0](https://github.com/elastic/cookbook-elasticsearch/tree/v3.3.0) (2017-08-30)
- nil templates skip startup scripts (#585)

## [v3.2.2](https://github.com/elastic/cookbook-elasticsearch/tree/v3.2.2) (2017-08-29)
- Bump ES version to 5.5.2 (#606)

## [v3.2.1](https://github.com/elastic/cookbook-elasticsearch/tree/v3.2.1) (2017-07-17)
- Bump ES version to 5.5.0, add 5.4.2 and 5.4.3 as well (#594)

## [v3.2.0](https://github.com/elastic/cookbook-elasticsearch/tree/v3.2.0) (2017-05-21)
- Provide additional documentation about logging options, update template (#577)
- Allow others to read elasticsearch log dir (#570)
- Bump ES version to 5.4.0 (#569)

## [v3.1.1](https://github.com/elastic/cookbook-elasticsearch/tree/v3.1.1) (2017-05-01)
- Add hashes for ES 5.3.1 (#562)
- Add hashes for ES 5.3.2 (#567)

## [v3.1.0](https://github.com/elastic/cookbook-elasticsearch/tree/v3.1.0) (2017-04-18)
- Add Chef 13.x support for this cookbook (#561)
- Reintroduce chef_proxy settings (#557)

## [v3.0.5](https://github.com/elastic/cookbook-elasticsearch/tree/v3.0.5) (2017-04-06)
- Bump ES version to 5.3.0 (#550)
- Fix permissions for elasticsearch.yml and log4j2.properties (#555)

## [v3.0.4](https://github.com/elastic/cookbook-elasticsearch/tree/v3.0.4) (2017-03-02)
- Bump ES version to 5.2.2 (#550)

## [v3.0.3](https://github.com/elastic/cookbook-elasticsearch/tree/v3.0.3) (2017-02-09)
- Fix URL support for plugins (#525)
- Add support for versions 5.0.2, 5.1.1, 5.1.2, 5.2.0
- Make 5.2.0 the default version
- Add a note about upgrading to new versions (#527)
- Foodcritic/Rubocop style cleanup
- Fix ruby version build on travis
- remove tarball directory recursively

## [v3.0.2](https://github.com/elastic/cookbook-elasticsearch/tree/v3.0.2) (2016-11-29)

- Ensure bin/elasticsearch-plugin uses the proper environment (#523)
- Bump default Elasticsearch version from v5.0.0 to v5.0.1

## [v3.0.1](https://github.com/elastic/cookbook-elasticsearch/tree/v3.0.1) (2016-11-09)

- Fix incorrect MAX_MAP_COUNT default to be '262144' to match init scripts (#516)

## [v3.0.0](https://github.com/elastic/cookbook-elasticsearch/tree/v3.0.0) (2016-11-07)

Breaking changes that were needed for v5.0.0 support (#497, #512, #424, #478, #503):
  - We dropped the fancy logic for figuring out the requested version of Elasticsearch to be installed. You should pass it on the resource or in the recipe, but we no longer do a bunch of logic to figure out what you meant -- we favor being explicit now.
  - We now start the service by default, instead of only `:enable` but not `:start`.
  - Dropped `gc_options` parameter of elasticsearch_configure, and now have `jvm.options`. We've also dropped thread_stack_size and env_options, as they aren't used in the upstream packaging as defaults anymore.
  - Install the tarball and package files into the same locations. There's no more `/usr/local`.
  - Install types are now 'strings', not :symbols. `node['elasticsearch'][<resource>][<param>]` sets any `elasticsearch::default` recipe.

For more on breaking changes, read [3aa8740](https://github.com/elastic/cookbook-elasticsearch/commit/3aa8740da5182f4a29761e0ea350048764bc0752) and [1ccd013](https://github.com/elastic/cookbook-elasticsearch/commit/1ccd013821cbfe83197c1ebba7fdb3acadc3d88f).

- Switch to the `manage_home false` property of newer Chef versions (#406)
- Use YAML library directly from now on for elasticsearch.yml (#470)
- Add support for Ubuntu 16.04 / CentOS 7.2, both using systemd (#501, #502)
- Support and use 'repository' type on `elasticsearch_install` by default (#476)
- Based on the latest v5.0.0 packages, tweak the permissions for some directories slightly (#513)
- Drop preferIPv4 test (#475), discovery.zen.ping settings (#437), and others.
- Add Java 8 testing by default (#510), bump newer Chef versions (#503, #505)
- Start using exact plugin names, case sensitive (#485)

## [v2.4.0](https://github.com/elastic/cookbook-elasticsearch/tree/v2.4.0) (2016-09-15)

- Update attributes for 2.3.5 and 2.4.0 versions. Use 2.4.0 version as default for installation and tests. [\#496](https://github.com/elastic/cookbook-elasticsearch/issues/496) and [\#490](https://github.com/elastic/cookbook-elasticsearch/issues/490)
- Added a LICENSE file (Apache 2), metadata, and linting
- Remove chef 11 compatibility from metadata, update cookstyle and Berkshelf, various Chef standards [\#481](https://github.com/elastic/cookbook-elasticsearch/issues/481)
- Improve environment file formatting: Remove quotes from vars that don't need it, strip superfluous spaces from ES_JAVA_OPTS [\#477](https://github.com/elastic/cookbook-elasticsearch/issues/477)

## [v2.3.2](https://github.com/elastic/cookbook-elasticsearch/tree/v2.3.2) (2016-06-17)

- Update init scripts and configs to latest [\#461](https://github.com/elastic/cookbook-elasticsearch/issues/461)
- Don't make environment file executable [\#474](https://github.com/elastic/cookbook-elasticsearch/issues/474)
- Don't make config YAML file executable [\#465](https://github.com/elastic/cookbook-elasticsearch/issues/465)
- Make latest Foodcritic rules pass [\#466](https://github.com/elastic/cookbook-elasticsearch/issues/466)
- ES 2.3.3 SHA256 sums and default version [\#464](https://github.com/elastic/cookbook-elasticsearch/issues/464)
- Point to determine_download_url instead of non-existent get_package_url [\#463](https://github.com/elastic/cookbook-elasticsearch/issues/463)

## [v2.3.1](https://github.com/elastic/cookbook-elasticsearch/tree/v2.3.1) (2016-05-06)

- Update documentation for dir in elasticsearch_install [\#453](https://github.com/elastic/cookbook-elasticsearch/issues/453)
- Define custom matchers helpers for notification testing [\#458](https://github.com/elastic/cookbook-elasticsearch/issues/458)
- Add checksums for version 2.3.2 [\#457](https://github.com/elastic/cookbook-elasticsearch/issues/457)
- Default ES version bump to 2.3.2 [\#459](https://github.com/elastic/cookbook-elasticsearch/issues/459)
- Fix quoting bug in plugin remove action [\#455](https://github.com/elastic/cookbook-elasticsearch/issues/455)
- Fix typo in README [\#456](https://github.com/elastic/cookbook-elasticsearch/issues/456)

## [v2.3.0](https://github.com/elastic/cookbook-elasticsearch/tree/v2.3.0) (2016-04-07)

- Add checksums for 2.3.1 [\#451](https://github.com/elastic/cookbook-elasticsearch/issues/451)

## [v2.2.2](https://github.com/elastic/cookbook-elasticsearch/tree/v2.2.2) (2016-03-22)

- elasticsearch_configure provider should not modify default resource parameters [\#445](https://github.com/elastic/cookbook-elasticsearch/issues/445)

## [v2.2.1](https://github.com/elastic/cookbook-elasticsearch/tree/v2.2.1) (2016-03-04)

- Incorrectly setting allocated memory in the `ES\_JAVA\_OPTS` variable [\#434](https://github.com/elastic/cookbook-elasticsearch/issues/434)
- elasticsearch_service/service_actions accepts (but does not support) Symbols [\#438](https://github.com/elastic/cookbook-elasticsearch/issues/438)

## [v2.2.0](https://github.com/elastic/cookbook-elasticsearch/tree/v2.2.0) (2016-02-08)

- Max heap size is too large [\#427](https://github.com/elastic/cookbook-elasticsearch/issues/427)
- How to define discovery.zen.ping.unicast.hosts [\#426](https://github.com/elastic/cookbook-elasticsearch/issues/426)
- elasticsearch\_plugin install lacks proxy support [\#415](https://github.com/elastic/cookbook-elasticsearch/issues/415)
- Default ES version needs upgrading \(2.1.0 \> 2.1.1\) [\#411](https://github.com/elastic/cookbook-elasticsearch/issues/411)
- config dirs/files and install dirs/files should be owned by root, not es\_user [\#405](https://github.com/elastic/cookbook-elasticsearch/issues/405)
- Reinstalls elasticserach every chef run [\#404](https://github.com/elastic/cookbook-elasticsearch/issues/404)
- Permission problem when installing Watcher or Shield [\#423](https://github.com/elastic/cookbook-elasticsearch/issues/423)
- Installing shield and watcher plugins fail with AccessDeniedException [\#421](https://github.com/elastic/cookbook-elasticsearch/issues/421)
- Plugin removal is broken [\#418](https://github.com/elastic/cookbook-elasticsearch/issues/418)
- elasticsearch\_configure documentation example missing path\_home [\#413](https://github.com/elastic/cookbook-elasticsearch/issues/413)
- Init script can't start [\#390](https://github.com/elastic/cookbook-elasticsearch/issues/390)
- ruby command not found [\#378](https://github.com/elastic/cookbook-elasticsearch/issues/378)
- ES 2.2.0 installation fails [\#429](https://github.com/elastic/cookbook-elasticsearch/issues/429)
- Can't install plugin twice [\#408](https://github.com/elastic/cookbook-elasticsearch/issues/408)
- Error running recipe on AWS Opsworks [\#403](https://github.com/elastic/cookbook-elasticsearch/issues/403)
- ES 2.1.0 support [\#402](https://github.com/elastic/cookbook-elasticsearch/issues/402)
- Any provision to make it Chef 11.10 compatible? [\#401](https://github.com/elastic/cookbook-elasticsearch/issues/401)
- gateway.expected\_nodes default should be 0 [\#399](https://github.com/elastic/cookbook-elasticsearch/issues/399)
- Add the defaults for slowlogs in logging.yml [\#398](https://github.com/elastic/cookbook-elasticsearch/issues/398)
- elasticsearch\_service resource doesn't work with short syntax [\#397](https://github.com/elastic/cookbook-elasticsearch/issues/397)
- What is supposed to happen when a config file is changed? [\#394](https://github.com/elastic/cookbook-elasticsearch/issues/394)
- Doc request - how to create data nodes vs master nodes [\#393](https://github.com/elastic/cookbook-elasticsearch/issues/393)
- Plugin install isn't idempotent [\#392](https://github.com/elastic/cookbook-elasticsearch/issues/392)
- Question - Are custom configs required everywhere?  [\#391](https://github.com/elastic/cookbook-elasticsearch/issues/391)
- Is :tarball or :package the preferred installation type?  [\#389](https://github.com/elastic/cookbook-elasticsearch/issues/389)
- Support Amazon platform for init scripts [\#387](https://github.com/elastic/cookbook-elasticsearch/issues/387)
- "ArgumentError: wrong number of arguments \(1 for 0\)" at resource\_configure.rb [\#386](https://github.com/elastic/cookbook-elasticsearch/issues/386)
- Do I need to do a Java Installation myself for this to work? [\#385](https://github.com/elastic/cookbook-elasticsearch/issues/385)
- Support ES 2.0 [\#384](https://github.com/elastic/cookbook-elasticsearch/issues/384)
- plugin install does not work [\#382](https://github.com/elastic/cookbook-elasticsearch/issues/382)
- Compile error w/ 1.0.3 and Chef Server 12 [\#379](https://github.com/elastic/cookbook-elasticsearch/issues/379)
- Allow template cookbook override in \_configure [\#376](https://github.com/elastic/cookbook-elasticsearch/issues/376)
- 1.0.2 Issues with pid files [\#374](https://github.com/elastic/cookbook-elasticsearch/issues/374)
- Consider using the resource name as a common shared set of resources [\#373](https://github.com/elastic/cookbook-elasticsearch/issues/373)
- elasticsearch\_install broken with v1.0.1 [\#371](https://github.com/elastic/cookbook-elasticsearch/issues/371)
- Compile Error [\#370](https://github.com/elastic/cookbook-elasticsearch/issues/370)
- wrong number of arguments \(1 for 0\) [\#369](https://github.com/elastic/cookbook-elasticsearch/issues/369)
- fixes typo in readme [\#428](https://github.com/elastic/cookbook-elasticsearch/pull/428) ([spuder](https://github.com/spuder))
- Plugin removal functionality restored [\#420](https://github.com/elastic/cookbook-elasticsearch/pull/420) ([dbaggott](https://github.com/dbaggott))
- Update to ES 2.1.1 [\#412](https://github.com/elastic/cookbook-elasticsearch/pull/412) ([dbaggott](https://github.com/dbaggott))
- Makes code examples have color [\#396](https://github.com/elastic/cookbook-elasticsearch/pull/396) ([spuder](https://github.com/spuder))
- Updates docs to show package are now default install [\#395](https://github.com/elastic/cookbook-elasticsearch/pull/395) ([spuder](https://github.com/spuder))
- Update the README to remove a typo [\#381](https://github.com/elastic/cookbook-elasticsearch/pull/381) ([jtwarren](https://github.com/jtwarren))
- Correct the full changelog links [\#375](https://github.com/elastic/cookbook-elasticsearch/pull/375) ([eheydrick](https://github.com/eheydrick))
- add missing matchers [\#368](https://github.com/elastic/cookbook-elasticsearch/pull/368) ([thomasdziedzic](https://github.com/thomasdziedzic))

## [v2.1.1](https://github.com/elastic/cookbook-elasticsearch/tree/v2.1.1) (2016-01-08)

- elasticsearch\_plugin install lacks proxy support [\#415](https://github.com/elastic/cookbook-elasticsearch/issues/415)
- Default ES version needs upgrading \(2.1.0 \> 2.1.1\) [\#411](https://github.com/elastic/cookbook-elasticsearch/issues/411)
- Reinstalls elasticserach every chef run [\#404](https://github.com/elastic/cookbook-elasticsearch/issues/404)
- Installing shield and watcher plugins fail with AccessDeniedException [\#421](https://github.com/elastic/cookbook-elasticsearch/issues/421)
- Plugin removal is broken [\#418](https://github.com/elastic/cookbook-elasticsearch/issues/418)
- elasticsearch\_configure documentation example missing path\_home [\#413](https://github.com/elastic/cookbook-elasticsearch/issues/413)
- Init script can't start [\#390](https://github.com/elastic/cookbook-elasticsearch/issues/390)
- ruby command not found [\#378](https://github.com/elastic/cookbook-elasticsearch/issues/378)
- Can't install plugin twice [\#408](https://github.com/elastic/cookbook-elasticsearch/issues/408)
- Error running recipe on AWS Opsworks [\#403](https://github.com/elastic/cookbook-elasticsearch/issues/403)
- ES 2.1.0 support [\#402](https://github.com/elastic/cookbook-elasticsearch/issues/402)
- Any provision to make it Chef 11.10 compatible? [\#401](https://github.com/elastic/cookbook-elasticsearch/issues/401)
- gateway.expected\_nodes default should be 0 [\#399](https://github.com/elastic/cookbook-elasticsearch/issues/399)
- Add the defaults for slowlogs in logging.yml [\#398](https://github.com/elastic/cookbook-elasticsearch/issues/398)
- elasticsearch\_service resource doesn't work with short syntax [\#397](https://github.com/elastic/cookbook-elasticsearch/issues/397)
- What is supposed to happen when a config file is changed? [\#394](https://github.com/elastic/cookbook-elasticsearch/issues/394)
- Doc request - how to create data nodes vs master nodes [\#393](https://github.com/elastic/cookbook-elasticsearch/issues/393)
- Plugin install isn't idempotent [\#392](https://github.com/elastic/cookbook-elasticsearch/issues/392)
- Question - Are custom configs required everywhere?  [\#391](https://github.com/elastic/cookbook-elasticsearch/issues/391)
- Is :tarball or :package the preferred installation type?  [\#389](https://github.com/elastic/cookbook-elasticsearch/issues/389)
- Support Amazon platform for init scripts [\#387](https://github.com/elastic/cookbook-elasticsearch/issues/387)
- "ArgumentError: wrong number of arguments \(1 for 0\)" at resource\_configure.rb [\#386](https://github.com/elastic/cookbook-elasticsearch/issues/386)
- Do I need to do a Java Installation myself for this to work? [\#385](https://github.com/elastic/cookbook-elasticsearch/issues/385)
- Support ES 2.0 [\#384](https://github.com/elastic/cookbook-elasticsearch/issues/384)
- plugin install does not work [\#382](https://github.com/elastic/cookbook-elasticsearch/issues/382)
- Compile error w/ 1.0.3 and Chef Server 12 [\#379](https://github.com/elastic/cookbook-elasticsearch/issues/379)
- Allow template cookbook override in \_configure [\#376](https://github.com/elastic/cookbook-elasticsearch/issues/376)
- 1.0.2 Issues with pid files [\#374](https://github.com/elastic/cookbook-elasticsearch/issues/374)
- Consider using the resource name as a common shared set of resources [\#373](https://github.com/elastic/cookbook-elasticsearch/issues/373)
- elasticsearch\_install broken with v1.0.1 [\#371](https://github.com/elastic/cookbook-elasticsearch/issues/371)
- Compile Error [\#370](https://github.com/elastic/cookbook-elasticsearch/issues/370)
- wrong number of arguments \(1 for 0\) [\#369](https://github.com/elastic/cookbook-elasticsearch/issues/369)
- missing chef resource expectations in specs in 1.0.1 [\#367](https://github.com/elastic/cookbook-elasticsearch/issues/367)
- Use predictable attributes/values for version, download URL, and checksum [\#366](https://github.com/elastic/cookbook-elasticsearch/issues/366)
- Rubocop & foodcritic cleanup  [\#365](https://github.com/elastic/cookbook-elasticsearch/issues/365)
- elasticsearch\_plugin installs plugins with the wrong permissions [\#363](https://github.com/elastic/cookbook-elasticsearch/issues/363)
- Double-dependency on curl [\#360](https://github.com/elastic/cookbook-elasticsearch/issues/360)
- OS X Support [\#358](https://github.com/elastic/cookbook-elasticsearch/issues/358)
- Plugin removal functionality restored [\#420](https://github.com/elastic/cookbook-elasticsearch/pull/420) ([dbaggott](https://github.com/dbaggott))
- Update to ES 2.1.1 [\#412](https://github.com/elastic/cookbook-elasticsearch/pull/412) ([dbaggott](https://github.com/dbaggott))
- Makes code examples have color [\#396](https://github.com/elastic/cookbook-elasticsearch/pull/396) ([spuder](https://github.com/spuder))
- Updates docs to show package are now default install [\#395](https://github.com/elastic/cookbook-elasticsearch/pull/395) ([spuder](https://github.com/spuder))
- Update the README to remove a typo [\#381](https://github.com/elastic/cookbook-elasticsearch/pull/381) ([jtwarren](https://github.com/jtwarren))
- Correct the full changelog links [\#375](https://github.com/elastic/cookbook-elasticsearch/pull/375) ([eheydrick](https://github.com/eheydrick))
- add missing matchers [\#368](https://github.com/elastic/cookbook-elasticsearch/pull/368) ([thomasdziedzic](https://github.com/thomasdziedzic))
- Adds integration test for plugins in default environment [\#361](https://github.com/elastic/cookbook-elasticsearch/pull/361) ([bwvoss](https://github.com/bwvoss))

## [2.1.0](https://github.com/elastic/cookbook-elasticsearch/tree/v2.1.0) (2015-12-01)

- ES 2.1.0 support [\#402](https://github.com/elastic/cookbook-elasticsearch/issues/402)

## [2.0.1](https://github.com/elastic/cookbook-elasticsearch/tree/v2.0.1) (2015-12-01)

- Any provision to make it Chef 11.10 compatible? [\#401](https://github.com/elastic/cookbook-elasticsearch/issues/401)
- gateway.expected\_nodes default should be 0 [\#399](https://github.com/elastic/cookbook-elasticsearch/issues/399)
- Add the defaults for slowlogs in logging.yml [\#398](https://github.com/elastic/cookbook-elasticsearch/issues/398)

## [2.0.0](https://github.com/elastic/cookbook-elasticsearch/tree/v2.0.0) (2015-11-23)

- Upgrading by package needs cleanup [\#331](https://github.com/elastic/cookbook-elasticsearch/issues/331)
- Minimal init scripts, preferrably from the packaged versions of ES [\#321](https://github.com/elastic/cookbook-elasticsearch/issues/321)
- Remove extra env file, or follow packaged conventions [\#320](https://github.com/elastic/cookbook-elasticsearch/issues/320)
- Remove system limit adjustments [\#319](https://github.com/elastic/cookbook-elasticsearch/issues/319)
- Init script can't start [\#390](https://github.com/elastic/cookbook-elasticsearch/issues/390)
- elasticsearch\_service resource doesn't work with short syntax [\#397](https://github.com/elastic/cookbook-elasticsearch/issues/397)
- What is supposed to happen when a config file is changed? [\#394](https://github.com/elastic/cookbook-elasticsearch/issues/394)
- Doc request - how to create data nodes vs master nodes [\#393](https://github.com/elastic/cookbook-elasticsearch/issues/393)
- Plugin install isn't idempotent [\#392](https://github.com/elastic/cookbook-elasticsearch/issues/392)
- Question - Are custom configs required everywhere?  [\#391](https://github.com/elastic/cookbook-elasticsearch/issues/391)
- Is :tarball or :package the preferred installation type?  [\#389](https://github.com/elastic/cookbook-elasticsearch/issues/389)
- Support Amazon platform for init scripts [\#387](https://github.com/elastic/cookbook-elasticsearch/issues/387)
- "ArgumentError: wrong number of arguments \(1 for 0\)" at resource\_configure.rb [\#386](https://github.com/elastic/cookbook-elasticsearch/issues/386)
- Do I need to do a Java Installation myself for this to work? [\#385](https://github.com/elastic/cookbook-elasticsearch/issues/385)
- plugin install does not work [\#382](https://github.com/elastic/cookbook-elasticsearch/issues/382)
- Allow template cookbook override in \_configure [\#376](https://github.com/elastic/cookbook-elasticsearch/issues/376)
- Consider using the resource name as a common shared set of resources [\#373](https://github.com/elastic/cookbook-elasticsearch/issues/373)
- Recreate deploying-elasticsearch-with-chef tutorial [\#293](https://github.com/elastic/cookbook-elasticsearch/issues/293)
- Makes code examples have color [\#396](https://github.com/elastic/cookbook-elasticsearch/pull/396) ([spuder](https://github.com/spuder))
- Updates docs to show package are now default install [\#395](https://github.com/elastic/cookbook-elasticsearch/pull/395) ([spuder](https://github.com/spuder))

## [1.2.0](https://github.com/elastic/cookbook-elasticsearch/tree/v1.2.0) (2015-10-16)

- Compile error w/ 1.0.3 and Chef Server 12 [\#379](https://github.com/elastic/cookbook-elasticsearch/issues/379)
- OS X Support [\#358](https://github.com/elastic/cookbook-elasticsearch/issues/358)
- Dealing with plugin versions that don't match, Elasticsearch failing to start [\#330](https://github.com/elastic/cookbook-elasticsearch/issues/330)
- ruby command not found [\#378](https://github.com/elastic/cookbook-elasticsearch/issues/378)
- Update the README to remove a typo [\#381](https://github.com/elastic/cookbook-elasticsearch/pull/381) ([jtwarren](https://github.com/jtwarren))
- Correct the full changelog links [\#375](https://github.com/elastic/cookbook-elasticsearch/pull/375) ([eheydrick](https://github.com/eheydrick))

## [1.0.3](https://github.com/elastic/cookbook-elasticsearch/tree/v1.0.3) (2015-09-20)

-  1.0.2 Issues with pid files [\#374](https://github.com/elastic/cookbook-elasticsearch/issues/374)

## [1.0.2](https://github.com/elastic/cookbook-elasticsearch/tree/v1.0.2) (2015-09-20)

- enhancement : attribut path\_xxx and path.xxx [\#352](https://github.com/elastic/cookbook-elasticsearch/issues/352)
- It would be nice to be able to pass options to elasticsearch\_service [\#334](https://github.com/elastic/cookbook-elasticsearch/issues/334)
- elasticsearch\_install broken with v1.0.1 [\#371](https://github.com/elastic/cookbook-elasticsearch/issues/371)
- Compile Error [\#370](https://github.com/elastic/cookbook-elasticsearch/issues/370)
- wrong number of arguments \(1 for 0\) [\#369](https://github.com/elastic/cookbook-elasticsearch/issues/369)
- missing chef resource expectations in specs in 1.0.1 [\#367](https://github.com/elastic/cookbook-elasticsearch/issues/367)
- Rubocop & foodcritic cleanup  [\#365](https://github.com/elastic/cookbook-elasticsearch/issues/365)
- add missing matchers [\#368](https://github.com/elastic/cookbook-elasticsearch/pull/368) ([thomasdziedzic](https://github.com/thomasdziedzic))

## [1.0.1](https://github.com/elastic/cookbook-elasticsearch/tree/v1.0.1) (2015-09-15)

- Plugin resource's plugin\_dir should have a sensible default [\#345](https://github.com/elastic/cookbook-elasticsearch/issues/345)
- Elasticsearch user homedir deleted  [\#328](https://github.com/elastic/cookbook-elasticsearch/issues/328)
- Use predictable attributes/values for version, download URL, and checksum [\#366](https://github.com/elastic/cookbook-elasticsearch/issues/366)
- elasticsearch\_plugin installs plugins with the wrong permissions [\#363](https://github.com/elastic/cookbook-elasticsearch/issues/363)
- Double-dependency on curl [\#360](https://github.com/elastic/cookbook-elasticsearch/issues/360)
- poise dependency not found [\#356](https://github.com/elastic/cookbook-elasticsearch/issues/356)
- Documentation for using JSON node configuration [\#355](https://github.com/elastic/cookbook-elasticsearch/issues/355)
- Hardcoded checksums in library helpers [\#350](https://github.com/elastic/cookbook-elasticsearch/issues/350)
- Document default values for all resources [\#348](https://github.com/elastic/cookbook-elasticsearch/issues/348)
- 1.0 should have sensible documentation [\#344](https://github.com/elastic/cookbook-elasticsearch/issues/344)
- Adds integration test for plugins in default environment [\#361](https://github.com/elastic/cookbook-elasticsearch/pull/361) ([bwvoss](https://github.com/bwvoss))
- Clarify when overriding plugin\_dir is necessary [\#349](https://github.com/elastic/cookbook-elasticsearch/pull/349) ([michaelklishin](https://github.com/michaelklishin))
- Remove duplicate node.max\_local\_storage\_nodes setting from the config template [\#346](https://github.com/elastic/cookbook-elasticsearch/pull/346) ([eheydrick](https://github.com/eheydrick))

## [v1.0.0](https://github.com/elastic/cookbook-elasticsearch/tree/v1.0.0) (2015-07-16)

- Rename source method of install [\#332](https://github.com/elastic/cookbook-elasticsearch/issues/332)
- NEXT: Document the process for submitting PRs [\#270](https://github.com/elastic/cookbook-elasticsearch/issues/270)
- Travis CI not running on PRs from local branches [\#337](https://github.com/elastic/cookbook-elasticsearch/issues/337)
- Error executing action `install` on resource 'elasticsearch\_install' [\#335](https://github.com/elastic/cookbook-elasticsearch/issues/335)
- Document requirement on Chef 12+ [\#338](https://github.com/elastic/cookbook-elasticsearch/issues/338)
- Add lots of additional documentation [\#343](https://github.com/elastic/cookbook-elasticsearch/pull/343) ([martinb3](https://github.com/martinb3))
- Add contribution guidelines [\#342](https://github.com/elastic/cookbook-elasticsearch/pull/342) ([martinb3](https://github.com/martinb3))
- Run CI on master branch again, after rename [\#341](https://github.com/elastic/cookbook-elasticsearch/pull/341) ([martinb3](https://github.com/martinb3))
- Rename provider source to tarball [\#340](https://github.com/elastic/cookbook-elasticsearch/pull/340) ([martinb3](https://github.com/martinb3))

## [v0.3.14](https://github.com/elastic/cookbook-elasticsearch/tree/v0.3.14) (2015-07-16)

- NEXT: Model YML config after 'trim' config [\#322](https://github.com/elastic/cookbook-elasticsearch/issues/322)
- NEXT: Create a user resource and provider [\#269](https://github.com/elastic/cookbook-elasticsearch/issues/269)
- If bootstrap.mlockall is true, MAX\_LOCKED\_MEMORY should be set to unlimited in elasticsearch-env.sh [\#266](https://github.com/elastic/cookbook-elasticsearch/issues/266)
- Installation enhancement [\#222](https://github.com/elastic/cookbook-elasticsearch/issues/222)
- Plugins defined in databag do not get installed [\#89](https://github.com/elastic/cookbook-elasticsearch/issues/89)
- There is no customize recipe [\#326](https://github.com/elastic/cookbook-elasticsearch/issues/326)
- ES not starting when setting version to 1.5.2 or 1.6.0 [\#325](https://github.com/elastic/cookbook-elasticsearch/issues/325)
- Question - Does cookbook support rolling restarts? [\#315](https://github.com/elastic/cookbook-elasticsearch/issues/315)
- Loading attributes from the data DBI [\#313](https://github.com/elastic/cookbook-elasticsearch/issues/313)
- 0.3.13: service doesn't successfully start [\#312](https://github.com/elastic/cookbook-elasticsearch/issues/312)
- Restart doesn't work the first time if a stale PID exists [\#310](https://github.com/elastic/cookbook-elasticsearch/issues/310)
- Cannot install plugin 2.4.1 [\#308](https://github.com/elastic/cookbook-elasticsearch/issues/308)
- Proxy recipe should include nginx only based on configurabe attribute [\#307](https://github.com/elastic/cookbook-elasticsearch/issues/307)
- Queue capacity [\#301](https://github.com/elastic/cookbook-elasticsearch/issues/301)
- strange behavior with docker :bug: [\#300](https://github.com/elastic/cookbook-elasticsearch/issues/300)
- Vagrant: Undefined method 'provider' [\#298](https://github.com/elastic/cookbook-elasticsearch/issues/298)
- Error after upgrading the cookbook [\#297](https://github.com/elastic/cookbook-elasticsearch/issues/297)
- Setting version triggers java.lang.NoClassDefFoundError [\#296](https://github.com/elastic/cookbook-elasticsearch/issues/296)
- Elasticsearch running but not from service [\#290](https://github.com/elastic/cookbook-elasticsearch/issues/290)
- Elasticsearch throws ElasticsearchIllegalStateException on boot \(time based instance\) [\#288](https://github.com/elastic/cookbook-elasticsearch/issues/288)
- Prefix Definitions [\#285](https://github.com/elastic/cookbook-elasticsearch/issues/285)
- strange thinks happend if I override elasticsearch version  [\#283](https://github.com/elastic/cookbook-elasticsearch/issues/283)
- Chef::Mixin::Template::TemplateError on new ssl attributes [\#281](https://github.com/elastic/cookbook-elasticsearch/issues/281)
- The 0.3.13 release is missing the metadata.rb file [\#279](https://github.com/elastic/cookbook-elasticsearch/issues/279)
- berks upload fails due to .DS\_Store files found in 0.3.12 package on supermarket.chef.io [\#278](https://github.com/elastic/cookbook-elasticsearch/issues/278)
- 0.3.11 release [\#277](https://github.com/elastic/cookbook-elasticsearch/issues/277)
- Berkshelf treats 'recommends' as 'depends' [\#275](https://github.com/elastic/cookbook-elasticsearch/issues/275)
- Init Script + Existing PID File [\#274](https://github.com/elastic/cookbook-elasticsearch/issues/274)
- Version change doesn't work [\#273](https://github.com/elastic/cookbook-elasticsearch/issues/273)
- Please add an option to specify the desired shell to pass to the su command [\#260](https://github.com/elastic/cookbook-elasticsearch/issues/260)
- Attaching EBS takes a very long time and doesn't finish? [\#259](https://github.com/elastic/cookbook-elasticsearch/issues/259)
- 1.3.4 startup hangs for 10min and fails [\#257](https://github.com/elastic/cookbook-elasticsearch/issues/257)
- Plugin installation skipping [\#252](https://github.com/elastic/cookbook-elasticsearch/issues/252)
- Can't get Rake task to work \(either dependencies or installing Berkshelf\) [\#244](https://github.com/elastic/cookbook-elasticsearch/issues/244)
- Don't include build-essential just to be sure apt is up to date [\#241](https://github.com/elastic/cookbook-elasticsearch/issues/241)
- how to specify max\_map\_count? [\#239](https://github.com/elastic/cookbook-elasticsearch/issues/239)
- Nginx HTTP, Basic Auth and multiple nodes [\#238](https://github.com/elastic/cookbook-elasticsearch/issues/238)
- Installing Marvel [\#237](https://github.com/elastic/cookbook-elasticsearch/issues/237)
- Need help with creating EBS Volume [\#223](https://github.com/elastic/cookbook-elasticsearch/issues/223)
- If elasticsearch fails to extract, it won't be installed later [\#221](https://github.com/elastic/cookbook-elasticsearch/issues/221)
- uninitialized constant Extensions during Vagrant provisioning [\#212](https://github.com/elastic/cookbook-elasticsearch/issues/212)
- config.vm.provider not recognised using Vagrant 1.5.4 [\#207](https://github.com/elastic/cookbook-elasticsearch/issues/207)
- The Vagrant installation instructions are outdated [\#206](https://github.com/elastic/cookbook-elasticsearch/issues/206)
- How to specify path.data and path.logs? [\#202](https://github.com/elastic/cookbook-elasticsearch/issues/202)
- Cannot upgrade from 0.0.92 to 1.0.1 [\#197](https://github.com/elastic/cookbook-elasticsearch/issues/197)
- install\_plugin fails to run on initial install [\#176](https://github.com/elastic/cookbook-elasticsearch/issues/176)
- EBS volume clean up [\#172](https://github.com/elastic/cookbook-elasticsearch/issues/172)
- Cookbook default attributes get lifted to normal priority [\#168](https://github.com/elastic/cookbook-elasticsearch/issues/168)
- Fog doesn't respect "delete\_on\_termination" option in elasticsearch::ebs [\#146](https://github.com/elastic/cookbook-elasticsearch/issues/146)
- Use package options on both providers [\#336](https://github.com/elastic/cookbook-elasticsearch/pull/336) ([martinb3](https://github.com/martinb3))
- allow options passing to package provider [\#329](https://github.com/elastic/cookbook-elasticsearch/pull/329) ([scalp42](https://github.com/scalp42))
- set default resource actions [\#327](https://github.com/elastic/cookbook-elasticsearch/pull/327) ([nathwill](https://github.com/nathwill))
- Add a note about `next` branch [\#324](https://github.com/elastic/cookbook-elasticsearch/pull/324) ([martinb3](https://github.com/martinb3))
- Introduce provider and resource for configure [\#316](https://github.com/elastic/cookbook-elasticsearch/pull/316) ([martinb3](https://github.com/martinb3))
- First pass at install resource and two providers [\#309](https://github.com/elastic/cookbook-elasticsearch/pull/309) ([martinb3](https://github.com/martinb3))

## [v0.3.13](https://github.com/elastic/cookbook-elasticsearch/tree/v0.3.13) (2015-01-13)

## [0.3.12](https://github.com/elastic/cookbook-elasticsearch/tree/0.3.12) (2015-01-13)

- Guidance On Upgrading A Running ES Installation [\#271](https://github.com/elastic/cookbook-elasticsearch/issues/271)
- Supermarket release? [\#262](https://github.com/elastic/cookbook-elasticsearch/issues/262)
- version check always adds '-d' flag incorrectly. [\#255](https://github.com/elastic/cookbook-elasticsearch/issues/255)
- Version 0.3.11 not available on supermarket [\#250](https://github.com/elastic/cookbook-elasticsearch/issues/250)
- Missed multicast settings in template [\#248](https://github.com/elastic/cookbook-elasticsearch/issues/248)
- Data bags for test? [\#246](https://github.com/elastic/cookbook-elasticsearch/issues/246)
- Introduce user provider and resource [\#268](https://github.com/elastic/cookbook-elasticsearch/pull/268) ([martinb3](https://github.com/martinb3))
- First pass at framework with testing, rake, etc [\#249](https://github.com/elastic/cookbook-elasticsearch/pull/249) ([martinb3](https://github.com/martinb3))

## [0.3.11](https://github.com/elastic/cookbook-elasticsearch/tree/0.3.11) (2014-10-13)

- The init script should use the Chef embedded Ruby? [\#215](https://github.com/elastic/cookbook-elasticsearch/issues/215)
- Quick Fix for version update issues [\#178](https://github.com/elastic/cookbook-elasticsearch/issues/178)
- Don't seem to be able to change the version [\#100](https://github.com/elastic/cookbook-elasticsearch/issues/100)
- Multiple EBS mounting [\#232](https://github.com/elastic/cookbook-elasticsearch/issues/232)
- Just changing elasticsearch version attribute doesn't install intended version [\#225](https://github.com/elastic/cookbook-elasticsearch/issues/225)
- plugins not being loaded [\#171](https://github.com/elastic/cookbook-elasticsearch/issues/171)

## [0.3.10](https://github.com/elastic/cookbook-elasticsearch/tree/0.3.10) (2014-06-19)

- Single node cofiguration [\#220](https://github.com/elastic/cookbook-elasticsearch/issues/220)
- can we use apt\_repository resource to install a particular version [\#217](https://github.com/elastic/cookbook-elasticsearch/issues/217)
- Version attribute effect on download\_url is misleading [\#214](https://github.com/elastic/cookbook-elasticsearch/issues/214)
- Make config template configurable [\#153](https://github.com/elastic/cookbook-elasticsearch/issues/153)

## [0.3.9](https://github.com/elastic/cookbook-elasticsearch/tree/0.3.9) (2014-05-22)

- 1.1.1 doesn't work [\#210](https://github.com/elastic/cookbook-elasticsearch/issues/210)
- Why does this cookbook set the es max heap size to 60% of available memory? [\#209](https://github.com/elastic/cookbook-elasticsearch/issues/209)
- Failure when adding elasticsearch service [\#204](https://github.com/elastic/cookbook-elasticsearch/issues/204)
- New release? [\#203](https://github.com/elastic/cookbook-elasticsearch/issues/203)

## [0.3.8](https://github.com/elastic/cookbook-elasticsearch/tree/0.3.8) (2014-03-27)

- Avoid using `recommends "monit"` in metadata.rb [\#162](https://github.com/elastic/cookbook-elasticsearch/issues/162)
- Problem with ownership of pid in /var/run/ on restart of ubuntu [\#108](https://github.com/elastic/cookbook-elasticsearch/issues/108)
- SSL support with Nginx proxy [\#226](https://github.com/elastic/cookbook-elasticsearch/issues/226)
- Compatibility with 1.0.1 [\#195](https://github.com/elastic/cookbook-elasticsearch/issues/195)
- pid\_path is owned by elasticsearch [\#193](https://github.com/elastic/cookbook-elasticsearch/issues/193)
- \[Install plugin: merge!\] \(elasticsearch::plugins line 35\) [\#187](https://github.com/elastic/cookbook-elasticsearch/issues/187)
- Cookbook doesn't work with 1.0.0RCx versions - Startup broken based on behavior change [\#185](https://github.com/elastic/cookbook-elasticsearch/issues/185)
- Failure to locate 'elasticsearch.conf.erb' template  [\#184](https://github.com/elastic/cookbook-elasticsearch/issues/184)
- Question on attributes "methodology" [\#180](https://github.com/elastic/cookbook-elasticsearch/issues/180)
- print\_value docs don't mention elasticsearch [\#169](https://github.com/elastic/cookbook-elasticsearch/issues/169)
- update readme file with default attributes [\#166](https://github.com/elastic/cookbook-elasticsearch/issues/166)
- Index template config files [\#164](https://github.com/elastic/cookbook-elasticsearch/issues/164)
- Issues configuring unicast cluster [\#158](https://github.com/elastic/cookbook-elasticsearch/issues/158)
- elasticsearch default /usr/local/elasticsearch is no good for elasticsearch-env.sh [\#157](https://github.com/elastic/cookbook-elasticsearch/issues/157)

## [0.3.7](https://github.com/elastic/cookbook-elasticsearch/tree/0.3.7) (2013-10-28)

## [0.3.5](https://github.com/elastic/cookbook-elasticsearch/tree/0.3.5) (2013-10-27)

- ES Logging Not Working [\#151](https://github.com/elastic/cookbook-elasticsearch/issues/151)
- Adding Debian specific init script [\#98](https://github.com/elastic/cookbook-elasticsearch/pull/98) ([remkade](https://github.com/remkade))

## [0.3.4](https://github.com/elastic/cookbook-elasticsearch/tree/0.3.4) (2013-10-01)

- first install with plugins fails [\#138](https://github.com/elastic/cookbook-elasticsearch/issues/138)
- Custom Params for init.d start [\#134](https://github.com/elastic/cookbook-elasticsearch/issues/134)
- elasticsearch-cloud-aws plugin - fails to install, restarts service anyway [\#131](https://github.com/elastic/cookbook-elasticsearch/issues/131)
- init script - improvements needed [\#130](https://github.com/elastic/cookbook-elasticsearch/issues/130)
- Configure HTTP port range [\#129](https://github.com/elastic/cookbook-elasticsearch/issues/129)
- Elasticsearch fails to start with 0.90.3 and cloud-aws 1.12.0 [\#126](https://github.com/elastic/cookbook-elasticsearch/issues/126)
- Install plugin failure does not stop script execution [\#124](https://github.com/elastic/cookbook-elasticsearch/issues/124)
- search\_discovery causes unnecessary restarts [\#122](https://github.com/elastic/cookbook-elasticsearch/issues/122)
- chef-solo needs the 'cookbook' folder to have the same name as the cookbook [\#121](https://github.com/elastic/cookbook-elasticsearch/issues/121)
- Plugins not working if aws recipe is used [\#105](https://github.com/elastic/cookbook-elasticsearch/issues/105)

## [0.3.3](https://github.com/elastic/cookbook-elasticsearch/tree/0.3.3) (2013-08-01)

- BREAKING: Fog version does not create EBS volumes properly [\#94](https://github.com/elastic/cookbook-elasticsearch/issues/94)
- ulimit settings not used with start-stop-daemon [\#109](https://github.com/elastic/cookbook-elasticsearch/issues/109)
- mismatch in aws endpoint attributes [\#106](https://github.com/elastic/cookbook-elasticsearch/issues/106)
- Elasticsearch service restart at each chef run [\#104](https://github.com/elastic/cookbook-elasticsearch/issues/104)
- Installation fails: Error executing action `start` on resource 'service\[elasticsearch\]' [\#96](https://github.com/elastic/cookbook-elasticsearch/issues/96)

## [0.3.2](https://github.com/elastic/cookbook-elasticsearch/tree/0.3.2) (2013-08-01)

- role attributes ignored? [\#112](https://github.com/elastic/cookbook-elasticsearch/issues/112)
- Mismatched Data Dir permissions [\#111](https://github.com/elastic/cookbook-elasticsearch/issues/111)
- Changing nofile attribute is not idempotent [\#101](https://github.com/elastic/cookbook-elasticsearch/issues/101)
- Configure unicast\_hosts dynamically on non-AWS clusters via `search` [\#40](https://github.com/elastic/cookbook-elasticsearch/issues/40)

## [0.3.1](https://github.com/elastic/cookbook-elasticsearch/tree/0.3.1) (2013-06-18)

## [0.3.0](https://github.com/elastic/cookbook-elasticsearch/tree/0.3.0) (2013-06-10)

- Fog \>= 1.11.0 breaks run with elasticsearch::ebs [\#93](https://github.com/elastic/cookbook-elasticsearch/issues/93)
- elasticsearch::ebs fails if apt package cache is out of date [\#88](https://github.com/elastic/cookbook-elasticsearch/issues/88)
- Document bare minimum configuration for default recipe [\#87](https://github.com/elastic/cookbook-elasticsearch/issues/87)
- Centos 5 / RHEL 5 Support [\#86](https://github.com/elastic/cookbook-elasticsearch/issues/86)
- Proxy recipe has hardcoded localhost which fails if elasticsearch is not bound to that IP [\#85](https://github.com/elastic/cookbook-elasticsearch/issues/85)
- AJAX requests and nginx proxy [\#84](https://github.com/elastic/cookbook-elasticsearch/issues/84)
- Readme link to Chef-solo+elasticsearch tutorial doesn't work [\#83](https://github.com/elastic/cookbook-elasticsearch/issues/83)
- You must set ES\_CLASSPATH var [\#82](https://github.com/elastic/cookbook-elasticsearch/issues/82)
- Setting a custom installation directory doesn't work [\#79](https://github.com/elastic/cookbook-elasticsearch/issues/79)

## [0.2.7](https://github.com/elastic/cookbook-elasticsearch/tree/0.2.7) (2013-03-18)

## [0.2.6](https://github.com/elastic/cookbook-elasticsearch/tree/0.2.6) (2013-03-08)

- Broken attempted aws plugin installation by default [\#76](https://github.com/elastic/cookbook-elasticsearch/issues/76)
- Using setup with ELB [\#70](https://github.com/elastic/cookbook-elasticsearch/issues/70)

## [0.2.5](https://github.com/elastic/cookbook-elasticsearch/tree/0.2.5) (2013-03-01)

- Elasticsearch with node.client set to true [\#71](https://github.com/elastic/cookbook-elasticsearch/issues/71)

## [0.2.4](https://github.com/elastic/cookbook-elasticsearch/tree/0.2.4) (2013-02-27)

## [0.2.3](https://github.com/elastic/cookbook-elasticsearch/tree/0.2.3) (2013-02-27)

- When updating versions, the wrong version can be installed unless you manually clear node attributes \(chef server only\) [\#69](https://github.com/elastic/cookbook-elasticsearch/issues/69)
- The version of elasticsearch can only be set via elasticsearch/settings databag [\#68](https://github.com/elastic/cookbook-elasticsearch/issues/68)

## [0.2.2](https://github.com/elastic/cookbook-elasticsearch/tree/0.2.2) (2013-02-26)

## [0.2.1](https://github.com/elastic/cookbook-elasticsearch/tree/0.2.1) (2013-02-26)

- Unable to change elasticsearch version via role and version tag [\#61](https://github.com/elastic/cookbook-elasticsearch/issues/61)
- Creating new ebs volume is taking forever [\#60](https://github.com/elastic/cookbook-elasticsearch/issues/60)

## [0.2.0](https://github.com/elastic/cookbook-elasticsearch/tree/0.2.0) (2013-02-01)

- Failing installation test on master [\#56](https://github.com/elastic/cookbook-elasticsearch/issues/56)
- Error message when running start script [\#48](https://github.com/elastic/cookbook-elasticsearch/issues/48)

## [0.1.0](https://github.com/elastic/cookbook-elasticsearch/tree/0.1.0) (2013-01-28)

## [0.0.1](https://github.com/elastic/cookbook-elasticsearch/tree/0.0.1) (2013-01-28)

- Update Gists for Ark change [\#28](https://github.com/elastic/cookbook-elasticsearch/issues/28)
- Conflict with nginx cookbook [\#46](https://github.com/elastic/cookbook-elasticsearch/issues/46)
- version bump the metadata [\#42](https://github.com/elastic/cookbook-elasticsearch/issues/42)
- elasticsearch::test doesn't work in ec2 with chef server [\#41](https://github.com/elastic/cookbook-elasticsearch/issues/41)
- Nginx rpm install doesn't support chunkin module [\#38](https://github.com/elastic/cookbook-elasticsearch/issues/38)

## [0.0.6](https://github.com/elastic/cookbook-elasticsearch/tree/0.0.6) (2013-01-15)

- Cannot find a resource for create\_ebs on amazon version 2012.09 [\#44](https://github.com/elastic/cookbook-elasticsearch/issues/44)

## [0.0.5](https://github.com/elastic/cookbook-elasticsearch/tree/0.0.5) (2012-12-20)

- Add `discovery.ec2.tag` and similar to elasticsearch.yml [\#36](https://github.com/elastic/cookbook-elasticsearch/issues/36)
- Add support for setting cloud.aws.region using node.json [\#33](https://github.com/elastic/cookbook-elasticsearch/issues/33)
- Elasticsearch doesn't start after run 'sudo chef-client' over knife ssh [\#32](https://github.com/elastic/cookbook-elasticsearch/issues/32)
- Can't find Monit template? [\#29](https://github.com/elastic/cookbook-elasticsearch/issues/29)
- Monit doesn't start after machine reboot [\#14](https://github.com/elastic/cookbook-elasticsearch/issues/14)
- Probable bugs in install\_plugin.rb [\#12](https://github.com/elastic/cookbook-elasticsearch/issues/12)

## [0.0.4](https://github.com/elastic/cookbook-elasticsearch/tree/0.0.4) (2012-10-15)

## [0.0.3](https://github.com/elastic/cookbook-elasticsearch/tree/0.0.3) (2012-10-14)

- min\_mem should be the same as max\_mem [\#35](https://github.com/elastic/cookbook-elasticsearch/issues/35)
- The `elasticsearch::proxy\_nginx` should declare dependency on `nginx` cookbook [\#24](https://github.com/elastic/cookbook-elasticsearch/issues/24)
- Appears to install nginx even in cases when it's not requested \(no proxy\) [\#23](https://github.com/elastic/cookbook-elasticsearch/issues/23)

## [0.0.2](https://github.com/elastic/cookbook-elasticsearch/tree/0.0.2) (2012-08-18)

- -Xss128k is too low [\#25](https://github.com/elastic/cookbook-elasticsearch/issues/25)
- Ubuntu Tests Failing [\#22](https://github.com/elastic/cookbook-elasticsearch/issues/22)
- getting an error trying to install plugin [\#21](https://github.com/elastic/cookbook-elasticsearch/issues/21)
- you must set ES\_CLASSPATH [\#20](https://github.com/elastic/cookbook-elasticsearch/issues/20)
- Need a more comprehensive max\_mem calculation [\#15](https://github.com/elastic/cookbook-elasticsearch/issues/15)
- Missing support for status command of the elasticsearch service [\#11](https://github.com/elastic/cookbook-elasticsearch/issues/11)
- Discovery settings in elasticsearch.yml.erb [\#9](https://github.com/elastic/cookbook-elasticsearch/issues/9)
- Monit issues \(template file name, internal issues\) [\#8](https://github.com/elastic/cookbook-elasticsearch/issues/8)
- Align elasticsearch-env.sh.erb with elasticsearch.in.sh [\#3](https://github.com/elastic/cookbook-elasticsearch/issues/3)
