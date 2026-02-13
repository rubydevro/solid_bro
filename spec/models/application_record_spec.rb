require "rails_helper"

RSpec.describe SolidBro::ApplicationRecord, type: :model do
  it "is abstract" do
    expect(described_class).to be_abstract_class
  end

  it "inherits from ActiveRecord::Base" do
    expect(described_class.superclass).to eq(ActiveRecord::Base)
  end
end

