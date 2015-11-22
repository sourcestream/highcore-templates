#!/bin/sh

bundle install
/usr/bin/env ruby - "$@" <<RUBY

require 'highcore_sparkle'
require 'trollop'

options = Trollop::options do
  opt :stack_definition, 'JSON-encoded stack definition', :type => :string, :required => true
  opt :template, 'Name of the stack template', :type => :string, :required => true
  opt :template_path, 'Path to the template directory', :type => :string, :required => true
end

puts HighcoreSparkle::generate(options[:template_path], options[:template], options[:stack_definition])

RUBY