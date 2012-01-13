module WelcomeCycle

  class Config
    attr_accessor :base_class, :welcome_cycle_start_date, :welcome_cycle_end_date

    def initialize
      @welcome_cycle_start_date = :trial_stared_at
      @welcome_cycle_end_date = :trial_ends_at
    end
  end

end