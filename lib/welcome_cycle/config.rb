module WelcomeCycle

  class Config
    attr_accessor :base_class, :welcome_cycle_start_date, :welcome_cycle_end_date
    attr_reader :before_run, :after_run

    def initialize
      @welcome_cycle_start_date = :trial_stared_at
      @welcome_cycle_end_date   = :trial_ends_at
    end

    def before(&block)
      @before_run = block
    end

    def after(&block)
      @after_run = block
    end

  end

end