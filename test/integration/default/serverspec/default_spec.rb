# Encoding: utf-8

require_relative 'spec_helper'

describe command('which curl') do
  its(:stdout) { should match(/curl/) }
  its(:exit_status) { should eq 0 }
end
