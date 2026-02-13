require "rails_helper"

RSpec.describe "Jobs retry and discard", type: :request do
  it "retries a failed job and redirects to failed tab" do
    job = SolidQueue::Job.create!(
      queue_name: "default",
      class_name: "RetryJob",
      arguments: [{ "job_class" => "RetryJob" }],
      priority: 0,
      scheduled_at: Time.current
    )
    SolidQueue::FailedExecution.create!(job: job, error: { message: "boom" })

    put "/solid_bro/jobs/#{job.id}/retry"
    expect(response).to redirect_to("/solid_bro/jobs/#{job.id}")
  end

  it "discards a job and redirects back to current scope" do
    job = SolidQueue::Job.create!(
      queue_name: "default",
      class_name: "DiscardJob",
      arguments: [{ "job_class" => "DiscardJob" }],
      priority: 0,
      scheduled_at: Time.current
    )

    expect {
      delete "/solid_bro/jobs/#{job.id}/discard", params: { scope: "all" }
    }.to change(SolidQueue::Job, :count).by(-1)

    expect(response).to redirect_to("/solid_bro/jobs?scope=all")
  end
end

