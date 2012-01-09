module WelcomeCycle
  class Email

    def initialize
    end

    def deliver(base_class)
      WelcomeCycleMailer.send(mailer_method_name).deliver
      record_sending!
    end

    private

      def record_sending!
        # Log/Store that the email was sent
      end

      def mailer_method_name
        name.gsub(/\s/, '_').downcase
      end
  end
end
