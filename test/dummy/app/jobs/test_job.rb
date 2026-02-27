class TestJob < ApplicationJob
  queue_as :default

  def perform(index = nil)
    Rails.logger.info "TestJob #{index} executed at #{Time.current}"
  end
end
