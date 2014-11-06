require 'spec_helper'
require 'swagger/docs/config'

describe Swagger::Docs::Config do
  subject { described_class }

  describe "::base_api_controller" do
    let(:base_controller) { double }

    it "allows assignment of another class" do
      subject.base_api_controller = base_controller
      expect(subject.base_api_controller).to eq(base_controller)
    end
  end

  describe "::base_applications" do
    before { allow(subject).to receive(:base_application).and_return(:app) }

    it "defaults to [base_application] array" do
      expect(subject.base_applications).to eq [:app]
    end
  end
end
