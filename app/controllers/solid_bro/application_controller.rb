module SolidBro
  class ApplicationController < ActionController::Base
    # Support both Pagy 9.x (Backend) and Pagy 8+/43.x (Method)
    if defined?(Pagy::Backend)
      include Pagy::Backend
    elsif defined?(Pagy::Method)
      include Pagy::Method
    end
    protect_from_forgery with: :exception
  end
end
