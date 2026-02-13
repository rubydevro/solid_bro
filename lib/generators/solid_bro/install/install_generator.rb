# frozen_string_literal: true

module SolidBro
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Installs SolidBro and adds asset manifest entries"

      def add_assets_to_manifest
        manifest_path = Rails.root.join("app/assets/config/manifest.js")

        if manifest_path.exist?
          manifest_content = File.read(manifest_path)

          unless manifest_content.include?("solid_bro/application.css")
            append_file manifest_path, "\n//= link solid_bro/application.css"
          end

          unless manifest_content.include?("solid_bro/application.js")
            append_file manifest_path, "\n//= link solid_bro/application.js"
          end
        else
          # Create manifest.js if it doesn't exist (for Sprockets)
          create_file manifest_path, <<~MANIFEST
            //= link_tree ../images
            //= link_directory ../stylesheets .css
            //= link_directory ../javascripts .js
            //= link solid_bro/application.css
            //= link solid_bro/application.js
          MANIFEST
        end
      end

      def add_sprockets_precompile
        return unless defined?(Sprockets)

        application_config_path = Rails.root.join("config/application.rb")

        if application_config_path.exist?
          application_content = File.read(application_config_path)

          unless application_content.include?("solid_bro")
            inject_into_file application_config_path,
              after: "class Application < Rails::Application\n" do
              <<~RUBY
                # SolidBro assets
                config.assets.precompile += %w[solid_bro/application.css solid_bro/application.js]
              RUBY
            end
          end
        end
      end
    end
  end
end
