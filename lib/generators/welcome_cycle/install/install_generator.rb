module WelcomeCycle
  module Generators
    class InstallGenerator < Rails::Generators::Base

      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def copy_welcome_cycle_mailer
        copy_file 'welcome_cycle_mailer.rb', '/mailers/welcome_cycle_mailer.rb'
      end

      def copy_email_list
        copy_file 'welcome_cycle.rb', 'config/initializers/welcome_cycle.rb'
      end

    end
  end
end