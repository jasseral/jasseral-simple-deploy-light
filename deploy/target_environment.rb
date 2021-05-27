#!/usr/bin/env ruby
# frozen_string_literal: true

# Determine if HEAD is tagged and detect the environment

require 'open3'

command = 'git describe --broken --contains HEAD'
stdout, _stderr, status = Open3.capture3(command)

if !status.success?
  puts 'dev'
elsif stdout.include? '-rc'
  puts 'uat'
else
  puts 'production'
end
