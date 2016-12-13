# Encoding: utf-8

require 'timeout'
require 'bundler/setup'

namespace :style do
  require 'cookstyle'
  require 'rubocop/rake_task'
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby) do |task|
    # see templatestack's .rubocop.yml for comparison
    task.patterns = ['**/*.rb']

    # only show the files with failures
    task.formatters = ['files']

    # abort rake on failure
    task.fail_on_error = true
  end

  require 'foodcritic'
  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    # 'search_gems' doesn't work, but :search_gems does
    t.options = { :search_gems => true, # allows us to add addl gems with more rules
                  :fail_tags => ['correctness'],
                  :chef_version => '12.4.1' }
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby']

desc 'Run Test Kitchen integration tests'
task :integration do
  require 'kitchen'
  Kitchen.logger = Kitchen.default_file_logger
  sh 'kitchen test -c'
end

desc 'Destroy test kitchen instances'
task :destroy do
  Kitchen.logger = Kitchen.default_file_logger
  Kitchen::Config.new.instances.each(&:destroy)
end

require 'rspec/core/rake_task'
desc 'Run ChefSpec unit tests'
RSpec::Core::RakeTask.new(:spec) do |t, _args|
  t.rspec_opts = 'test/unit --format documentation'
end

# The default rake task should just run it all
task default: %w(style spec integration)

begin
  Timeout.timeout(15) do
    require 'kitchen/rake_tasks'
    Kitchen::RakeTasks.new
  end
rescue Exception => e
  if e.class.to_s =~ /^Timeout::|^Kitchen::|LoadError/
    STDERR.puts "[!] Omitting Kitchen tasks [#{e.class}: #{e.message} at #{e.backtrace.first}]\n\n"
  else
    raise e
  end
end
