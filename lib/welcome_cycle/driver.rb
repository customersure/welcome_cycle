module WelcomeCycle
  class Driver
    def self.run
      WelcomeCycle::EmailRegister.instance.emails.each { |e| e.send_to_recipients! }
    end
  end
end