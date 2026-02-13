require "rails_helper"

RSpec.describe "Jobs index", type: :request do
  let!(:ready_job) do
    SolidQueue::Job.create!(
      queue_name: "default",
      class_name: "TestJob",
      arguments: [{ "job_class" => "TestJob" }],
      priority: 0,
      scheduled_at: Time.current
    )
  end

  let!(:failed_job) do
    SolidQueue::Job.create!(
      queue_name: "mailers",
      class_name: "FailedJob",
      arguments: [{ "job_class" => "FailedJob" }],
      priority: 0,
      scheduled_at: Time.current
    ).tap do |job|
      SolidQueue::FailedExecution.create!(job: job, error: { message: "boom" })
    end
  end

  let!(:finished_job) do
    SolidQueue::Job.create!(
      queue_name: "finisher",
      class_name: "FinishedJob",
      arguments: [{ "job_class" => "FinishedJob" }],
      priority: 0,
      scheduled_at: Time.current,
      finished_at: 1.minute.ago
    )
  end

  def get_jobs(scope: "all", params: {})
    get "/solid_bro/jobs", params: params.merge(scope: scope)
  end

  it "renders the jobs index successfully" do
    get_jobs
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("All jobs")
  end

  it "filters by job class name" do
    get_jobs(scope: "all", params: { class_name: "FailedJob" })
    expect(response.body).to include("FailedJob")
    expect(response.body).not_to include("TestJob")
  end

  it "scopes failed jobs" do
    get_jobs(scope: "failed")
    expect(response.body).to include("FailedJob")
    expect(response.body).not_to include("TestJob")
  end

  it "scopes finished jobs" do
    get_jobs(scope: "finished")
    expect(response.body).to include("FinishedJob")
    expect(response.body).not_to include("TestJob")
  end

  it "filters by queue name" do
    get_jobs(scope: "all", params: { queue_name: "mailers" })
    expect(response.body).to include("mailers")
    expect(response.body).not_to include("default")
  end

  it "filters finished jobs by finished_at range" do
    get_jobs(scope: "finished", params: { finished_at_start: 2.minutes.ago.iso8601, finished_at_end: Time.current.iso8601 })
    expect(response.body).to include("FinishedJob")

    get_jobs(scope: "finished", params: { finished_at_start: 10.minutes.ago.iso8601, finished_at_end: 5.minutes.ago.iso8601 })
    expect(response.body).not_to include("FinishedJob")
  end
end

