# frozen_string_literal: true

module SolidBro
  class RecurringTasksController < ApplicationController
    def index
      @recurring_tasks = SolidQueue::RecurringTask.order(:key)
    end
  end
end
