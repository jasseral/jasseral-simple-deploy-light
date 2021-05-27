#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'config'

DOCKERFILE = 'Dockerfile'

def base_build_options
  [
    'docker build .',
    "--file #{DOCKERFILE}",
    #'--build-arg DJANGO_SETTINGS_MODULE=config.settings.production',
    "--build-arg ENVIRONMENT=#{environment}", #This is only on build - time
    "--tag #{container_repository}:#{environment}",
    "--tag #{container_repository}:#{GIT_COMMIT_SHA}"
  ]
end

def extra_build_options
  case environment
  when 'production', 'uat'
    [
      "--tag #{container_repository}:#{GIT_TAG}"
    ]
  when 'dev'
    [
      "--tag #{container_repository}:#{GIT_BRANCH}"
    ]
  else
    puts "Environment '#{environment}' is not valid."
    exit 1
  end
end

def build_image(build_command)
  cmd(build_command.join(' '))
end

def environment
  ENV['environment']
end

def parse_args
  ARGV << '-h' if ARGV.empty?
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: #{$PROGRAM_NAME} [environment]"

    opts.on('-e', '--environment ENVIRONMENT', 'Environment target for the build') do |opt|
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

  build_command = base_build_options + extra_build_options

  puts 'Building the container images…'
  build_image(build_command)
end

main if $PROGRAM_NAME == __FILE__
