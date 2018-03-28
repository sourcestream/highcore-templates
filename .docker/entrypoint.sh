#!/bin/sh

export HOME=/tmp
bundle install --deployment --quiet --path vendor/bundle
ruby - "$@" <<RUBY

require 'rubygems'
require 'bundler'
Bundler.setup(:default)

require 'highcore_sparkle'
require 'trollop'

options = Trollop::options do
  opt :stack_definition, 'JSON-encoded stack definition', :type => :string, :required => true
  opt :template, 'Name of the stack template', :type => :string, :required => true
  opt :template_path, 'Path to the registry directory for the selected template', :type => :string, :default => Dir.pwd
end

puts HighcoreSparkle::generate(options[:template_path], options[:template], options[:stack_definition])

RUBY