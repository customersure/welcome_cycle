# WelcomeCycle::Email.new do
#   name = "Welcome"
#   days = [3,5,7]
#
#   Organisation.where
#   conditions {
#
#   }
# end

# WelcomeCycle::Email.new { name = "luke" }

module WelcomeCycle
  class Email

    attr_accessor :name #, :conditions, :days_after_signup, :days_before_trial_end

    def initialize(name, &block)
      self.name = name

      instance_eval(&block)
    end

    # def deliver(base_class)
    #   WelcomeCycleMailer.send(mailer_method_name).deliver
    #   record_sending!
    # end
    #
    # private
    #
    #   def record_sending!
    #     # Log/Store that the email was sent
    #   end
    #
    #   def mailer_method_name
    #     name.gsub(/\s/, '_').downcase
    #   end
  end
end
