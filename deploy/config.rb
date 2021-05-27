#!/usr/bin/env ruby
# frozen_string_literal: true

PROJECT = 'skibutlers.com-admin-light'

GIT_BRANCH = `git branch --show-current 2> /dev/null`.strip
GIT_COMMIT_SHA = `git rev-parse --verify HEAD 2> /dev/null`.strip
GIT_TAG = `git describe --tags 2> /dev/null`.strip

CONTAINER_REGISTRY_NAME = {
  #dev: 'CraftCaeDev',
  dev: 'jasseralg',
  uat: 'CraftCaeUAT'
}.freeze

def container_registry
  # Here we add the registry , I need to improve this for be generic  
  # "#{CONTAINER_REGISTRY_NAME[environment.to_sym]}.azurecr.io".downcase
  "#{CONTAINER_REGISTRY_NAME}".downcase
end

def container_repository
  "#{container_registry}/#{PROJECT}"
end

def cmd(command, verbose: true)
  puts(command) if verbose
  system(command, exception: true)
end
