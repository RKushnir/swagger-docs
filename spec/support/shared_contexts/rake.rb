require "rake"

shared_context "rake" do
  let(:rake)      { Rake::Application.new }
  let(:task_path) { "lib/tasks/#{task_name.split(":").first}" }
  subject         { rake[task_name] }

  before do
    Rake.application = rake
    root_path = File.expand_path("../../../../", __FILE__)
    Rake.application.rake_require(task_path, [root_path])

    Rake::Task.define_task(:environment)
  end
end
