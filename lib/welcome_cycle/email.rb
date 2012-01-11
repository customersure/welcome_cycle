# Positive days is after signup
# Negative days is from the trial end


# WelcomeCycle::Email.new("Tab code for website") do
#   days 1, 5, 15, -5
#   scope do
#     where('created_at < ?', Date.today)
#   end
# end

module WelcomeCycle

  class Email

    def initialize(name, &block)
      @scope_chain = nil
      @name = name
      instance_eval &block
      WelcomeCycle::EmailRegister.instance << self
    end

    def days(*days)
      raise ArgumentError, "You cannot specify day zero in the welcome cycle" if days.detect { |d| d.zero? }
      raise ArgumentError, "You must specify at least one day in the welcome cycle that you'd like this email to be sent on" if days.empty?
      @days = days
    end

    def scope(&block)
      @scope_chain = block
    end

    def send_to_recipients!
      recipients.each { |r| deliver(r) }
    end

    def recipients
      return [] if @days.nil? # Don't like this but cannot workout how to detect whether the block given to initialize contains days.
      recipients = WelcomeCycle.config.base_class
      recipients = recipients.where(date_conditions)
      if @scope_chain.nil?
        recipients.all
      else
        recipients.instance_eval(&@scope_chain)
      end
    end

    def deliver(r)
      WelcomeCycleMailer.send(template_name, r).deliver
    end

    private

      def template_name
        @name.downcase.gsub(/\s/, '_')
      end

      def date_conditions
        conditions = ['']
        @days.each_with_index do |day_in_cycle, i|
          field = day_in_cycle > 0 ? WelcomeCycle.config.welcome_cycle_start_date : WelcomeCycle.config.welcome_cycle_end_date
          conditions[0] << " OR " unless i.zero?
          conditions[0] << "date(#{field}) = ?"
          conditions << Date.today - day_in_cycle # Positive: 6th-5.days = 1st / Negative: 25th--5.days = 30th
        end
        conditions
      end

  end

end
