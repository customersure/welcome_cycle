require "welcome_cycle/version"
require "welcome_cycle/driver"
require "welcome_cycle/email"

module WelcomeCycle
  
  @@emails = []
  
  def register(email_attributes)
    @@emails << WelcomeCycle::Email.new(email_attributes)
  end

  def self.base_class=(value)
    WelcomeCycle.config.base_class = value
  end

end