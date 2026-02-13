require "rails_helper"

RSpec.describe "SolidBro pages", type: :request do
  it "renders job show with details" do
    job = SolidQueue::Job.create!(
      queue_name: "default",
      class_name: "DetailJob",
      arguments: [{ "job_class" => "DetailJob", "arguments" => [1] }],
      priority: 0,
      scheduled_at: Time.current
    )

    get "/solid_bro/jobs/#{job.id}"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Job ##{job.id}")
    expect(response.body).to include("DetailJob")
  end

  it "renders queues index" do
    SolidQueue::Job.create!(
      queue_name: "email",
      class_name: "MailJob",
      arguments: [{ "job_class" => "MailJob" }],
      priority: 0,
      scheduled_at: Time.current
    )

    get "/solid_bro/queues"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Queues")
    expect(response.body).to include("email")
  end

  it "renders workers index" do
    SolidQueue::Process.create!(
      kind: "worker",
      last_heartbeat_at: Time.current,
      pid: 123,
      hostname: "test-host",
      metadata: "{}",
      name: "worker-1"
    )

    get "/solid_bro/workers"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Workers")
    expect(response.body).to include("worker-1")
  end

  it "renders recurring tasks index" do
    SolidQueue::RecurringTask.create!(
      key: "test_task",
      schedule: "* * * * *",
      command: "TestCommand",
      description: "A test recurring task",
      static: true,
      priority: 0,
      created_at: Time.current,
      updated_at: Time.current
    )

    get "/solid_bro/recurring-tasks"
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Recurring tasks")
    expect(response.body).to include("test_task")
  end
end

