module WelcomeCycle
  class Config
    include Singleton
    attr_accessor :base_class

    def initialize
      @base_class = Organisation
    end
  end
end