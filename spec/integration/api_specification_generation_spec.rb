require 'rails_helper'
require 'tmpdir'

RSpec.describe 'api specification generation' do
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

  it 'generates resource listing and api declarations' do
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

      api_declaration = JSON.parse(File.read('public/properties.json'))
      expect(api_declaration).to eq(
        "apiVersion" => "1.0",
        "swaggerVersion" => "1.2",
        "basePath" => "/",
        "resourcePath" => "properties",
        "apis" => [{
          "path" => "properties/{id}",
          "operations" => [{
            "summary" => "Fetches all properties",
            "parameters" =>  [{
              "paramType" => "path",
              "name" => "id",
              "type" => "integer",
              "description" => "Property ID",
              "required" => true
            }],
            "responseMessages" => [
              {"code" => 401, "responseModel" => nil, "message" => "Unauthorized"},
              {"code" => 406, "responseModel" => nil, "message" => "Not Acceptable"},
            ],
            "method" => "get",
            "nickname" => "Properties#show"
          },],
        },],
        "authorizations" => nil)
    end
  end
end
