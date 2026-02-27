namespace :jobs do
  desc "Enqueue 100 test jobs"
  task enqueue_test: :environment do
    count = ENV.fetch("COUNT", "100").to_i
    count.times do |i|
      TestJob.perform_later(i + 1)
    end
    puts "Enqueued #{count} test jobs."
  end
end
