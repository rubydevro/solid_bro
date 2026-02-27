# test/dummy/verify_setup.rb
ENV["RAILS_ENV"] ||= "test"
require_relative "config/environment"

# Load Solid Queue Schema
load Rails.root.join("db", "queue_schema.rb")

puts "Checking SolidQueue tables..."
begin
  count = SolidQueue::Job.count
  puts "SolidQueue::Job count: #{count}"
  puts "SolidQueue setup verified!"
rescue => e
  puts "Verification failed: #{e.message}"
  exit 1
end

# Create a test job class
class TestJob < ApplicationJob
  queue_as :default
  def perform(*args)
    puts "Job performed!"
  end
end

puts "Enqueuing a job..."
TestJob.perform_later("test")
puts "Job enqueued. New count: #{SolidQueue::Job.count}"
