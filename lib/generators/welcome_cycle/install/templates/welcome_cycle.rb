WelcomeCycle.configure do |c|
  c.base_class = Subscription
  c.welcome_cycle_start_date = :trial_started_at
  c.welcome_cycle_end_date = :trial_ends_at
end

# run 'rails generate welcome_cycle:email name_for_your_email_here' to add new welcome cycle emails