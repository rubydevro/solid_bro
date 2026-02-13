module SolidBro
  class QueuesController < ApplicationController
    def index
      # Aggregate job counts by queue
      @queues = SolidQueue::Job.group(:queue_name).count
    end

    def pause
      # Placeholder for pausing queue
      redirect_to queues_path, notice: "Queue pause logic not implemented."
    end

    def resume
      # Placeholder for resuming queue
      redirect_to queues_path, notice: "Queue resume logic not implemented."
    end
  end
end
