module WelcomeCycle

  class Config
    attr_accessor :base_class, :welcome_cycle_start_date, :welcome_cycle_end_date

    def initialize
      @base_class = Organisation if defined?(Organisation)
      @welcome_cycle_start_date = :created_at
      @welcome_cycle_end_date = :trial_ends_at
    end
  end

end