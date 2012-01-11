require 'singleton'

require "welcome_cycle/version"
require "welcome_cycle/driver"
require "welcome_cycle/email"
require "welcome_cycle/email_register"
require "welcome_cycle/config"

module WelcomeCycle

  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= WelcomeCycle::Config.new
    yield(config)
  end

end