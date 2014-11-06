require 'bundler/setup'
require 'spec_helper'

ENV["RAILS_ENV"] = 'test'

require File.expand_path('../rails_app/config/environment.rb',  __FILE__)

Rails.backtrace_cleaner.remove_silencers!

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
