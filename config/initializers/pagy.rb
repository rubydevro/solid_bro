# frozen_string_literal: true

# Pagy default configuration for SolidBro
# Supports Pagy 9.x, 8.x, and 43.x
# See https://ddnexus.github.io/pagy/resources/initializer/

if defined?(Pagy)
  if Pagy.respond_to?(:options)
    # Pagy 8+/43.x uses Pagy.options with 'limit'
    Pagy.options[:limit] = 25
  elsif defined?(Pagy::DEFAULT)
    # Pagy 9.x uses Pagy::DEFAULT with 'items'
    Pagy::DEFAULT[:items] = 25
  end
end
