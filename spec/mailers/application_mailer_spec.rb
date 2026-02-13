require "rails_helper"

RSpec.describe SolidBro::ApplicationMailer, type: :mailer do
  it "sets a default from address" do
    expect(described_class.default[:from]).to eq("from@example.com")
  end
end

