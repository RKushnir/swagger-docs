require 'spec_helper'
require 'swagger/docs/api_declaration_file'
require 'swagger/docs/api_declaration_file_metadata'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/blank'

describe Swagger::Docs::ApiDeclarationFile do
  let(:apis) do
    [
      {
        path: "sample/{id}",
        operations: [
          {
            summary: "Updates an existing User",
            parameters: [
              {param_type: :path, name: :id, type: :integer, description: "User Id", required: true},
              {param_type: :form, name: :first_name, type: :string, description: "First name", required: false},
              {param_type: :form, name: :last_name, type: :string, description: "Last name", required: false},
              {param_type: :form, name: :email, type: :string, description: "Email address", required: false},
              {param_type: :form, name: :tag, type: :Tag, description: "Tag object", required: true}
            ],
            response_messages: [
              {code: 401, message: "Unauthorized"},
              {code: 404, message: "Not Found"},
              {code: 406, message: "Not Acceptable"}
            ],
            notes: "Only the given fields are updated.",
            method: :put,
            nickname: "Api::V1::Sample#update",
            consumes: ["application/json", "text/xml"]
          }
        ]
      }
    ]
  end

  let(:models) do
    {
      Tag: {
        id: :Tag,
        required: [:id],
        properties: {
          id: {type: :integer, description: "User Id"},
          first_name: {type: :string, description: "First Name"},
          last_name: {type: :string, description: "Last Name"}
        },
        description: "A Tag object."
      }
    }
  end

  let(:metadata) do
    Swagger::Docs::ApiDeclarationFileMetadata.new("1.0", "api/v1/sample", "http://api.no.where/", "")
  end

  describe "#generate_resource" do

    it "generates the appropriate response" do
      declaration = described_class.new(metadata, apis, models)

      expected_response = {
        "apiVersion"=> declaration.api_version,
        "swaggerVersion"=> declaration.swagger_version,
        "basePath"=> declaration.base_path,
        "apis"=> declaration.apis,
        "resourcePath"=> declaration.resource_path,
        models: declaration.models,
        "resourceFilePath" => declaration.resource_file_path,
        "authorizations" => {}
      }
      expect(declaration.generate_resource).to eq(expected_response)
    end
  end

  describe "#models" do
    context "with camelize_model_properties set to true" do
      it "returns a models hash that's ready for output" do
        declaration = described_class.new(metadata, apis, models)
        allow(declaration).to receive(:camelize_model_properties).and_return(true)
        expected_models_hash = {
          "Tag" =>
          {
            "id" => :Tag,
            "required" =>[:id],
            "properties" =>
            {
              "id" =>{"type"=>:integer, "description"=>"User Id"},
              "firstName"=>{"type"=>:string, "description"=>"First Name"},
              "lastName"=>{"type"=>:string, "description"=>"Last Name"},
            },
            "description"=>"A Tag object."
          }
        }

        expect(declaration.models).to eq(expected_models_hash)
      end
    end

    context "with camelize_model_properties set to false" do
      it "returns a models hash that's ready for output" do
        declaration = described_class.new(metadata, apis, models)
        allow(declaration).to receive(:camelize_model_properties).and_return(false)
        expected_models_hash = {
          "Tag" =>
          {
            "id" => :Tag,
            "required" =>[:id],
            "properties" =>
            {
              "id" =>{"type"=>:integer, "description"=>"User Id"},
              "first_name"=>{"type"=>:string, "description"=>"First Name"},
              "last_name"=>{"type"=>:string, "description"=>"Last Name"},
            },
            "description"=>"A Tag object."
          }
        }

        expect(declaration.models).to eq(expected_models_hash)
      end
    end
  end

  describe "#apis" do
    it "returns a api hash that's ready for output" do
      declaration = described_class.new(metadata, apis, models)
      expected_apis_array = [
        {
          "path"=>"sample/{id}",
          "operations"=>[
            {
              "summary"=>"Updates an existing User",
              "parameters"=>[
                {"paramType"=>:path, "name"=>:id, "type"=>:integer, "description"=>"User Id", "required"=>true},
                {"paramType"=>:form, "name"=>:first_name, "type"=>:string, "description"=>"First name", "required"=>false},
                {"paramType"=>:form, "name"=>:last_name, "type"=>:string, "description"=>"Last name", "required"=>false},
                {"paramType"=>:form, "name"=>:email, "type"=>:string, "description"=>"Email address", "required"=>false},
                {"paramType"=>:form, "name"=>:tag, "type"=>:Tag, "description"=>"Tag object", "required"=>true}
              ],
              "responseMessages"=>[
                {"code"=>401, "message"=>"Unauthorized"},
                {"code"=>404, "message"=>"Not Found"},
                {"code"=>406, "message"=>"Not Acceptable"}
              ],
              "notes"=>"Only the given fields are updated.",
              "method"=>:put,
              "nickname"=>"Api::V1::Sample#update",
              "consumes"=>["application/json", "text/xml"]
            }
          ]
        }
      ]
      expect(declaration.apis).to eq(expected_apis_array)
    end
  end
end
