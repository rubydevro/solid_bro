# frozen_string_literal: true

# Pagy default configuration for SolidBro
# Pagy 8+ has no extras/overflow; out-of-range pages are handled as empty page by default.
# See https://ddnexus.github.io/pagy/resources/initializer/
Pagy.options[:limit] = 25
