require 'action_controller/railtie'

class ApplicationController < ActionController::Base
  cattr_accessor :context
  self.context = "original"
end
