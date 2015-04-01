# Elasticsearch Chef Cookbook

This branch contains the next version of the cookbook. This cookbook has been
converted into a library cookbook.

## Recipes

### default

The default recipe creates an elasticsearch user and group with the default
options.

## Resources

### elasticsearch_user

Creates a user and group on the system for use by elasticsearch. Here is an
example with many of the default options and default values (all options except
a resource name may be omitted):

```ruby
elasticsearch_user 'elasticsearch' do
  username 'elasticsearch'
  groupname 'elasticsearch'
  homedir '/usr/local/elasticsearch'
  shell '/bin/bash'
  comment 'Elasticsearch User'

  action :create
end
```

### elasticsearch_install

Downloads the elasticsearch software, and unpacks it on the system. There are
currently two ways to install -- `package`, which downloads the appropriate
package from elasticsearch.org and uses the package manager to install it, and
`source` which downloads a tarball from elasticsearch.org and unpacks it in
/usr/local on the system. The resource name is not used for anything in
particular. This resource also comes with a `:remove` action which will remove
the package or directory elasticsearch was unpacked into.

Examples:

```
elasticsearch_install 'my_es_installation' do
  type :source # type of install
  dir '/usr/local' # where to install

  owner 'elasticsearch' # user and group to install under
  group 'elasticsearch'

  source_url "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.5.0.tar.gz"
  source_checksum "acf572c606552bc446cceef3f8e93814a363ba0d215b323a2864682b3abfbe45"

  action :install # could be :remove as well
end
```

```
elasticsearch_install 'my_es_installation' do
  type :source # type of install
  version '1.5.0'
  action :install # could be :remove as well
end
```

```
elasticsearch_install 'my_es_installation' do
  type :package # type of install
  package_url "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.5.0.deb"
  package_checksum "15a02a2bea74da2330bb78718efb3a8f83a2b2e040a6ee859e100a6556981f36"
  action :install # could be :remove as well
end
```

```
elasticsearch_install 'my_es_installation' do
  type :package # type of install
  version "1.5.0"
  action :install # could be :remove as well
end
```

## Testing

This cookbook is equipped with both unit tests (chefspec) and integration tests
(test-kitchen and serverspec). It also comes with rubocop and foodcritic tasks
in the supplied Rakefile. Contributions to this cookbook should include tests
for new features or bugfixes, with a preference for unit tests over integration
tests to ensure speedy testing runs. ***All tests and most other commands here
should be run using bundler*** and our standard Gemfile. This ensures that
contributions and changes are made in a standardized way against the same
versions of gems. We recommend installing rubygems-bundler so that bundler is
automatically inserting `bundle exec` in front of commands run in a directory
that contains a Gemfile.

A full test run of all tests and style checks would look like:
```bash
$ bundle exec rake style
$ bundle exec rake spec
$ bundle exec rake integration
$ bundle exec rake destroy
```
The final destroy is intended to clean up any systems that failed a test, and is
mostly useful when running with kitchen drivers for cloud providers, so that no
machines are left orphaned and costing you money.

### Fixtures

This cookbook supplies a few different test fixtures (under `test/fixtures/`)
that can be shared amongst any number of unit or integration tests: cookbooks,
environments, and nodes. Environments and nodes are automatically loaded into
chef-zero for both chefspec tests that run locally and serverspec tests that run
from test-kitchen.

It also contains 'platform data' that can be used to drive unit testing, for
example, you might read `httpd` for some platforms and `apache2` for others,
allowing you to write a single test for the Apache webserver. Unfortunately,
without further modifications to `busser` and `busser-serverspec`, the platform
data will not be available to serverspec tests.

### Style and Best Practices

Rubocop and Foodcritic evaluations may be made by running `rake style`. There
are no overrides for foodcritic rules, however the adjustments to
rubocop are made using the supplied `.rubocop.yml` file and have been documented
by comments within. Most notably, rubocop has been restricted to only apply to
`.rb` files.

Rubocop and foodcritic tests can be executed using `rake style`.

### Unit testing

Unit testing is done using the latest versions of Chefspec. The current default
test layout includes running against all supported platforms, as well as
stubbing data into chef-zero. This allows us to also test against chef search.
As is currently a best practice in the community, we will avoid the use of
chef-solo, but not create barriers to explicitly fail for chef-solo.

Unit tests can be executed using `rake spec`.

### Integration testing

Integration testing is accomplished using the latest versions of test-kitchen
and serverspec. Currently, this cookbook uses the busser-serverspec plugin for
copying serverspec files to the system being tested. There is some debate in the
community about whether this should be done using busser-rspec instead, and each
busser plugin has a slightly different feature set.

While the default test-kitchen configuration uses the vagrant driver, you may
override this using `~/.kitchen/config.yml` or by placing a `.kitchen.local.yml`
in the current directory. This allows you to run these integration tests using
any supported test-kitchen driver (ec2, rackspace, docker, etc).

Integration tests can be executed using `rake integration` or `kitchen test`.

## License

This software is licensed under the Apache 2 license, quoted below.

    Copyright (c) 2014 Elasticsearch <http://www.elasticsearch.org>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
