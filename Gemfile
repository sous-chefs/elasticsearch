source 'https://rubygems.org'

group :lint do
  gem 'cookstyle'
  gem 'foodcritic', '~> 6.0'
end

group :unit do
  gem 'berkshelf', '~> 5.0'
  gem 'molinillo', '>= 0.5', '< 0.6.0'
  gem 'chef-sugar'
  gem 'chefspec', '>= 4.2'
end

group :kitchen_common do
  gem 'test-kitchen'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant'
  gem 'vagrant-wrapper'
end

group :kitchen_rackspace do
  gem 'kitchen-rackspace'
end

group :kitchen_ec2 do
  gem 'kitchen-ec2'
end

group :development do
  gem 'growl'
  gem 'guard'
  gem 'guard-foodcritic'
  gem 'guard-kitchen'
  gem 'guard-rubocop'
  gem 'pry-nav'
  gem 'rb-fsevent'
  gem 'chef', '~> 13.0'
end
