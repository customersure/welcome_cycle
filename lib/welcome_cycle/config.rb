module WelcomeCycle

  class Config
    include Singleton

    attr_accessor :base_class, :trial_start_date, :trial_ends_date, :recipients_method

    def initialize
      @base_class = Organisation if defined?(Organisation)
      @trial_start_date = :created_at
      @trial_ends_date = :trial_ends_date
      @recipient_email_method = :welcome_cycle_recipients
    end
  end

end