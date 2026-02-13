module SolidBro
  class ApplicationController < ActionController::Base
    # Support both Pagy 9.x (Backend) and Pagy 8+/43.x (Method)
    if defined?(Pagy::Backend)
      include Pagy::Backend
    elsif defined?(Pagy::Method)
      include Pagy::Method
    end

    # Optional Pundit integration (only if the host app uses Pundit)
    if defined?(Pundit::Authorization)
      include Pundit::Authorization

      before_action :authorize_solid_bro!

      private

      # Expects a SolidBroPolicy in the host app:
      #   class SolidBroPolicy < Struct.new(:user, :solid_bro)
      #     def access?; user&.admin?; end
      #   end
      def authorize_solid_bro!
        authorize :solid_bro, :access?
      end
    end

    protect_from_forgery with: :exception
  end
end
