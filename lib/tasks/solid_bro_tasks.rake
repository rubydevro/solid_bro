require "securerandom"

namespace :solid_bro do
  desc "Seed SolidQueue jobs in various statuses for UI testing"
  task seed_jobs: :environment do
    puts "Creating demo SolidQueue jobs..."

    # Helper to build a base job payload
    def build_job_attrs(index, overrides = {})
      {
        queue_name: overrides[:queue_name] || "default",
        class_name: overrides[:class_name] || "DemoJob",
        arguments: [ { "job_class" => overrides[:class_name] || "DemoJob", "index" => index } ],
        priority: overrides.fetch(:priority, 0),
        scheduled_at: overrides[:scheduled_at] || Time.current
      }.merge(overrides.except(:queue_name, :class_name, :priority, :scheduled_at))
    end

    # Ready jobs (Solid Queue will create ready executions automatically)
    10.times do |i|
      SolidQueue::Job.create!(build_job_attrs(i, class_name: "ReadyDemoJob"))
    end
    puts "Created 10 ready jobs"

    # Failed jobs (remove ready execution so status resolves to failed)
    10.times do |i|
      job = SolidQueue::Job.create!(build_job_attrs(i, class_name: "FailedDemoJob", queue_name: "mailers"))
      job.ready_execution&.destroy! if job.respond_to?(:ready_execution)
      SolidQueue::FailedExecution.create!(job: job, error: { message: "boom ##{i}" })
    end
    puts "Created 10 failed jobs"

    # Finished jobs
    10.times do |i|
      finished_at = (i + 1).minutes.ago
      SolidQueue::Job.create!(
        build_job_attrs(i, class_name: "FinishedDemoJob", queue_name: "finisher", scheduled_at: finished_at, finished_at: finished_at)
      )
    end
    puts "Created 10 finished jobs"

    # Scheduled jobs (in the future; Solid Queue will track them as scheduled)
    10.times do |i|
      scheduled_at = (i + 1).minutes.from_now
      SolidQueue::Job.create!(
        build_job_attrs(i, class_name: "ScheduledDemoJob", queue_name: "scheduled", scheduled_at: scheduled_at, priority: 5)
      )
    end
    puts "Created 10 scheduled jobs"

    puts "Done seeding SolidQueue demo jobs."
  end
end
