module WelcomeCycle
  class Driver
    def self.run
      # TODO: Need to check we have a base_class
      WelcomeCycle::EmailRegister.instance.emails.each { |e| e.send_to_recipients! }
    end
  end
end