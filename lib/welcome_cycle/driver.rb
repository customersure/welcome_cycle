module WelcomeCycle
  class Driver
    def self.run
      raise 'WelcomeCycle is not configured! See the README config section for help.' if WelcomeCycle.config.nil?
      raise "You must set the 'base_class' option. See README config section." if WelcomeCycle.config.base_class.nil?
      WelcomeCycle::EmailRegister.instance.emails.each { |e| e.send_to_recipients! }
    end
  end
end