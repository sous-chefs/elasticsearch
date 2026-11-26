# frozen_string_literal: true

# Finish Git maintenance before cookbook-omnifetch copies scratch clones.
# These settings only affect this process and its child Git commands.
config_index = ENV.fetch('GIT_CONFIG_COUNT', '0').to_i
%w(maintenance.autoDetach gc.autoDetach).each do |key|
  ENV["GIT_CONFIG_KEY_#{config_index}"] = key
  ENV["GIT_CONFIG_VALUE_#{config_index}"] = 'false'
  config_index += 1
end
ENV['GIT_CONFIG_COUNT'] = config_index.to_s
