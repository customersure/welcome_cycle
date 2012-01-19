module WelcomeCycle

  class Email

    def initialize(name, &block)
      @name = name
      instance_eval &block
      raise "You must specify at least one day to send this email by specifying 'days_into_cycle' and/or 'days_offset_from_cycle_end'" if @days_into_cycle.nil? && @days_offset_from_cycle_end.nil?
      WelcomeCycle::EmailRegister.instance << self
    end

    def days_into_cycle(*days)
      raise ArgumentError, "'days_into_cycle' can only contain positive numbers" if days.detect { |d| d <= 0 }
      raise "When specifying 'days_into_cycle' you must set the 'welcome_cycle_start_date'. See README config section" if WelcomeCycle.config.welcome_cycle_start_date.nil?
      @days_into_cycle = days
    end

    def days_offset_from_cycle_end(*days)
      raise "When specifying 'days_offset_from_cycle_end' you must set the 'welcome_cycle_end_date' config section" if WelcomeCycle.config.welcome_cycle_end_date.nil?
      @days_offset_from_cycle_end = days
    end

    def scope(&block)
      @scope_chain = block
    end

    def send_to_recipients!
      recipients.each { |r| deliver(r) }
    end

    def recipients
      recipients = WelcomeCycle.config.base_class
      recipients = recipients.where(date_conditions)
      @scope_chain.nil? ? recipients.all : recipients.instance_eval(&@scope_chain)
    end

    def deliver(r)
      if defined?(Delayed) && (defined?(Delayed::Job) || defined?(Delayed::Worker))
        deliver_via_delayed_job(r)
      else
        deliver_directly(r)
      end
    end

    private

      def deliver_via_delayed_job(r)
        WelcomeCycleMailer.delay.send(template_name, r)
      end

      def deliver_directly(r)
        if mail_message_obj = WelcomeCycleMailer.send(template_name, r)
          mail_message_obj.deliver
        else
          raise "Failed to create Mail::Message object from the current template name '#{template_name}'. Check it is specified in your WelcomeCycleMailer."
        end
      end

      def template_name
        @name.downcase.gsub(/\s/, '_')
      end

      def date_conditions
        conditions = ['']
        [[WelcomeCycle.config.welcome_cycle_start_date, @days_into_cycle], [WelcomeCycle.config.welcome_cycle_end_date, @days_offset_from_cycle_end]].each do |field_name, cycle_days|
          next if cycle_days.nil?
          cycle_days.each do |day_in_cycle|
            conditions[0] << " OR " unless conditions[0].empty?
            conditions[0] << "date(`#{WelcomeCycle.config.base_class.table_name}`.`#{field_name}`) = ?"
            conditions << Time.now.utc.to_date - day_in_cycle # Positive: 6th-5.days = 1st / Negative: 25th--5.days = 30th
          end
        end
        conditions
      end

  end

end
