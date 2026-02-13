# frozen_string_literal: true

module SolidBro
  class JobsController < ApplicationController
    JOB_SCOPES = %w[all failed in_progress blocked scheduled finished].freeze

    def index
      @scope = JOB_SCOPES.include?(params[:scope]) ? params[:scope] : "all"
      @counts = job_counts
      base = scope_relation(@scope)
      base = apply_filters(base)
      @pagy, @jobs = pagy(base.order(created_at: :desc), limit: 25)
    end

    def show
      @job = SolidQueue::Job.find(params[:id])
    end

    def retry
      @job = SolidQueue::Job.find(params[:id])
      @job.retry if @job.respond_to?(:retry) && @job.failed?
      redirect_to jobs_path(scope: "failed"), notice: "Job retry requested."
    rescue StandardError => e
      redirect_to job_path(@job), alert: "Retry failed: #{e.message}"
    end

    def discard
      @job = SolidQueue::Job.find(params[:id])
      @job.discard
      redirect_to jobs_path(scope: params[:scope].presence || "all"), notice: "Job discarded."
    rescue StandardError => e
      redirect_to job_path(@job), alert: "Discard failed: #{e.message}"
    end

    private

    def scope_relation(scope)
      case scope
      when "failed"       then SolidQueue::Job.failed
      when "in_progress"  then SolidQueue::Job.joins(:claimed_execution)
      when "blocked"      then SolidQueue::Job.joins(:blocked_execution)
      when "scheduled"    then SolidQueue::Job.joins(:scheduled_execution)
      when "finished"     then SolidQueue::Job.finished
      else SolidQueue::Job
      end
    end

    def job_counts
      {
        "all" => SolidQueue::Job.count,
        "failed" => SolidQueue::Job.failed.count,
        "in_progress" => SolidQueue::Job.joins(:claimed_execution).count,
        "blocked" => SolidQueue::Job.joins(:blocked_execution).count,
        "scheduled" => SolidQueue::Job.joins(:scheduled_execution).count,
        "finished" => SolidQueue::Job.finished.count
      }
    end

    def apply_filters(relation)
      table = relation.respond_to?(:table_name) ? "#{relation.table_name}." : "solid_queue_jobs."

      if params[:class_name].present?
        term = params[:class_name].to_s.downcase
        term = SolidQueue::Job.sanitize_sql_like(term)
        relation = relation.where("LOWER(class_name) LIKE ?", "%#{term}%")
      end

      if params[:queue_name].present?
        term = params[:queue_name].to_s.downcase
        term = SolidQueue::Job.sanitize_sql_like(term)
        relation = relation.where("LOWER(queue_name) LIKE ?", "%#{term}%")
      end

      if @scope == "finished"
        relation = relation.where("finished_at >= ?", parse_datetime(params[:finished_at_start])) if params[:finished_at_start].present?
        relation = relation.where("finished_at <= ?", parse_datetime(params[:finished_at_end])) if params[:finished_at_end].present?
      else
        relation = relation.where("#{table}created_at >= ?", parse_datetime(params[:created_at_start])) if params[:created_at_start].present?
        relation = relation.where("#{table}created_at <= ?", parse_datetime(params[:created_at_end])) if params[:created_at_end].present?
      end

      relation
    end

    def parse_datetime(value)
      return nil if value.blank?
      Time.zone.parse(value.to_s)
    rescue ArgumentError
      nil
    end
  end
end
