module WelcomeCycle

  class Driver

    def self.run
      WelcomeCycle::EmailRegister.instance.emails
    end

  end

end