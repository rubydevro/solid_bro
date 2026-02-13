module SolidBro
  module ApplicationHelper
    # Support both Pagy 9.x (Frontend) and Pagy 8+/43.x (no separate module needed)
    if defined?(Pagy::Frontend)
      include Pagy::Frontend
    end

    # Pretty-print job arguments for display
    def format_job_arguments(arguments)
      return "—" if arguments.blank?
      JSON.pretty_generate(arguments)
    rescue StandardError
      # Fallback: break Ruby inspect for readability
      arguments.inspect.gsub("=>", " => ").gsub(", ", ",\n  ")
    end

    # Filter params to preserve when changing job scope tabs
    def filter_params_for_link
      params.permit(:class_name, :queue_name, :created_at_start, :created_at_end, :finished_at_start, :finished_at_end).to_h.compact_blank
    end

    def jobs_tab_class(scope)
      (params[:scope].presence || "all") == scope ? "active" : ""
    end

    def jobs_scope_title(scope)
      case scope
      when "all" then "All"
      when "failed" then "Failed"
      when "in_progress" then "In progress"
      when "blocked" then "Blocked"
      when "scheduled" then "Scheduled"
      when "finished" then "Finished"
      else "All"
      end
    end
  end
end
