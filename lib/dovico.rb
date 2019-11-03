require 'active_support'
require 'active_support/core_ext/hash'

module Dovico
  APP_DIRECTORY = "#{Dir.home}/.dovico/"
end

require 'dovico/version'
require 'dovico/api_client'
require 'dovico/app'
require 'dovico/config_parser'
require 'dovico/model/assignment'
require 'dovico/model/assignments'
require 'dovico/model/client'
require 'dovico/model/employee'
require 'dovico/model/project'
require 'dovico/model/task'
require 'dovico/model/task_group'
require 'dovico/model/time_entry'
require 'dovico/model/time_entry_formatter'
require 'dovico/model/time_entry_generator'
