require "rails_helper"

RSpec.describe "Queues", type: :request do
  before do
    SolidQueue::Job.create!(
      queue_name: "default",
      class_name: "TestJob",
      arguments: [{ "job_class" => "TestJob" }],
      priority: 0,
      scheduled_at: Time.current
    )
  end

  it "lists queues with counts" do
    get "/solid_bro/queues"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Queues")
    expect(response.body).to include("default")
  end

  it "redirects with notice on pause" do
    put "/solid_bro/queues/default/pause"
    expect(response).to redirect_to("/solid_bro/queues")
    follow_redirect!
    expect(response.body).to include("Queue pause logic not implemented.")
  end

  it "redirects with notice on resume" do
    put "/solid_bro/queues/default/resume"
    expect(response).to redirect_to("/solid_bro/queues")
    follow_redirect!
    expect(response.body).to include("Queue resume logic not implemented.")
  end
end

