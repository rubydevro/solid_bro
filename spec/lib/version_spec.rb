require "rails_helper"

RSpec.describe SolidBro::VERSION do
  it "is defined as a version string" do
    expect(SolidBro::VERSION).to be_a(String)
    expect(SolidBro::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end
end


