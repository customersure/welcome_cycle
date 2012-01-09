require "welcome_cycle/version"
require "welcome_cycle/driver"
require "welcome_cycle/email"
require "welcome_cycle/email_register"

module WelcomeCycle

  class << self
    attr_accessor :config
  end

  # WelcomeCycle.configure do |c|
  #   c.base_class = User
  # end

  def self.configure
    self.config ||= Config.new
    yield(config)
  end

end
