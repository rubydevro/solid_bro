# frozen_string_literal: true

# Pagy default configuration for SolidBro
# Pagy 8+ has no extras/overflow; out-of-range pages are handled as empty page by default.
# See https://ddnexus.github.io/pagy/resources/initializer/

# Support both Pagy 8+ (Pagy.options) and older versions (Pagy::DEFAULT)
if defined?(Pagy)
  if Pagy.respond_to?(:options)
    # Pagy 8+ uses Pagy.options
    Pagy.options[:limit] = 25
  elsif defined?(Pagy::DEFAULT)
    # Older Pagy versions use Pagy::DEFAULT
    # Try 'limit' first (Pagy 6+), fallback to 'items' (older versions)
    begin
      Pagy::DEFAULT[:limit] = 25
    rescue StandardError
      Pagy::DEFAULT[:items] = 25
    end
  end
end
