require 'rails_helper'
require 'tmpdir'

RSpec.describe 'resource listing generation' do
  include_context "rake"
  let(:task_name) { 'swagger:docs' }

  def generate_in_tmp_dir(&block)
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        subject.invoke
        block.call
      end
    end
  end

  it 'generates resource listing' do
    generate_in_tmp_dir do
      resource_listing = JSON.parse(File.read('public/api-docs.json'))
      expect(resource_listing).to eq(
        "apiVersion" => "1.0",
        "swaggerVersion" => "1.2",
        "basePath" => "/",
        "apis" => [
          {"path" => "properties.{format}", "description" => "Properties"},
          {"path" => "users.{format}", "description" => "Users"},
          {"path" => "groups.{format}", "description" => "Groups"}
        ],
        "authorizations" => nil
      )
    end
  end
end
