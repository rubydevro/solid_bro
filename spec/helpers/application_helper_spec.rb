require "rails_helper"

RSpec.describe SolidBro::ApplicationHelper, type: :helper do
  describe "#format_job_arguments" do
    it "pretty-prints JSON-serializable arguments" do
      args = [{ "job_class" => "TestJob", "arguments" => [1, 2, 3] }]
      formatted = helper.format_job_arguments(args)
      expect(formatted).to include("TestJob")
      expect(formatted).to include("\n")
    end

    it "returns an em dash for blank arguments" do
      expect(helper.format_job_arguments(nil)).to eq("—")
      expect(helper.format_job_arguments([])).to eq("—")
    end
  end
end

