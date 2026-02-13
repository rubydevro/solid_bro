module SolidBro
  class Engine < ::Rails::Engine
    isolate_namespace SolidBro

    # Automatically precompile engine assets for Sprockets
    initializer "solid_bro.assets.precompile", group: :all do |app|
      if app.config.respond_to?(:assets) && app.config.assets.respond_to?(:precompile)
        app.config.assets.precompile += %w[solid_bro/application.css solid_bro/application.js]
      end
    end

    # For Propshaft: automatically add assets to manifest in development/test
    # This ensures assets work without manual setup in development
    config.after_initialize do |app|
      if (Rails.env.development? || Rails.env.test?) && defined?(Propshaft)
        manifest_path = Rails.root.join("app/assets/config/manifest.js")

        if manifest_path.exist?
          manifest_content = File.read(manifest_path)

          needs_update = false
          updated_content = manifest_content.dup

          unless manifest_content.include?("solid_bro/application.css")
            updated_content += "\n//= link solid_bro/application.css"
            needs_update = true
          end

          unless manifest_content.include?("solid_bro/application.js")
            updated_content += "\n//= link solid_bro/application.js"
            needs_update = true
          end

          if needs_update
            File.write(manifest_path, updated_content)
            Rails.logger.info "SolidBro: Automatically added assets to manifest.js"
          end
        end
      end
    end
  end
end
