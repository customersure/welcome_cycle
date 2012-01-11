module WelcomeCycle
  class EmailRegister

    include Singleton

    attr_accessor :emails

    def initialize
      @emails = []
    end

    def <<(email)
      @emails << email
    end

    def each
      @emails.each { |email| yield(email) }
    end

  end
end
