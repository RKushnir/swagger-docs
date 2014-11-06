module Swagger
  module Docs
    class Task < Rails::Railtie
      rake_tasks do
        pattern = File.join(File.dirname(__FILE__),'../../tasks/*.rake')
        Dir[pattern].each {|f| load f }
      end
    end
  end
end
