#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'config'

def push_image
  cmd("docker push #{container_repository}:#{environment}")
  cmd("docker push #{container_repository}:#{GIT_COMMIT_SHA}")
  cmd("docker push #{container_repository}:#{GIT_BRANCH}") if environment == 'dev' && GIT_BRANCH != 'main'
  cmd("docker push #{container_repository}:#{GIT_TAG}") if %w[uat production].include? environment
end

def environment
  ENV['environment']
end

def parse_args
  ARGV << '-h' if ARGV.empty?
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: #{$PROGRAM_NAME} [environment]"

    opts.on('-e', '--environment ENVIRONMENT', 'Environment target for the push') do |opt|
      options[:environment] = opt
    end

    opts.on_tail('-h', '--help', 'Show this message') do
      puts opts
      exit
    end
  end.parse!

  raise OptionParser::MissingArgument unless options.length == 1

  ENV['environment'] = options[:environment]
  options
end

def main
  parse_args

  puts 'Pushing the container image…'
  push_image
end

main if $PROGRAM_NAME == __FILE__
