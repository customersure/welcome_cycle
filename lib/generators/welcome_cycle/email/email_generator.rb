module WelcomeCycle
  module Generators
    class EmailGenerator < Rails::Generators::NamedBase

      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def register_new_mail
        append_to_file 'lib/welcome_cycle.rb' do
          <<-EOS


WelcomeCycle::Email.new("#{file_name.gsub(/_/, ' ').capitalize}") do
  days 1, 10, -2 # on which days of the trial should the mail be sent?
  scope do
    # send if these Arel conditions are met
  end
end
          EOS
        end
      end

      def add_new_mailer_action
        gsub_file 'app/mailers/welcome_cycle_mailer.rb', '# your actions here', ''
        inject_into_class 'app/mailers/welcome_cycle_mailer.rb', WelcomeCycleMailer do
          <<-EOS

    def #{file_name}
    end
EOS
        end
      end

      def add_new_mailer_templates
        create_file "app/views/welcome_cycle_mailer/#{file_name}.text.erb"
        create_file "app/views/welcome_cycle_mailer/#{file_name}.html.erb"
      end
    end
  end
end