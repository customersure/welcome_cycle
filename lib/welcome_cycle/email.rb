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
      @scope_chain = Proc.new
      @name = name
      instance_eval &block
    end

    def days(*days)
      @days = days
      raise ArgumentError, "You cannot specify day zero in the welcome cycle" if days.detect { |d| d.zero? }
    end

    def scope(&block)
      @scope_chain = block
    end

    def send_to_recipients!
      recipients.each { |r| e.deliver(r) }
    end

    private

      def recipients
        recipients = WelcomeCycle.config.base_class
        recipients = recipients.where(date_conditions) if @days.present?
        if @scope_chain.blank?
          recipients.all
        else
          recipients.instance_eval(&@scope_chain)
        end
      end

      def deliver(r)
        puts "delivering email '#{template_name}' to #{r}"
        # WelcomeCycleMailer.send(template_name, r).deliver
      end

      def template_name
        @name.downcase.gsub(/%s/, '_')
      end

      def date_conditions
        conditions = ['']
        @days.each_with_index do |day_in_cycle, i|
          field = day_in_cycle > 0 ? WelcomeCycle.config.welcome_cycle_start_date : WelcomeCycle.config.welcome_cycle_end_date
          conditions[0] << " OR " unless i.zero?
          conditions[0] << "date(#{field}) = ?"
          conditions << Date.today - day_in_cycle.days # Positive: 6th-5.days = 1st / Negative: 25th--5.days = 30th
        end
        conditions
      end

  end

end
