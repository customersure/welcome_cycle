# welcome_cycle

`welcome_cycle` is a gem to send out a cycle of emails when a
customer signs up for a SaaS product.

# Install


# Defining new emails


# Config options
1) base_class – The model in your app to query for email recipients (E.g Organisation, Subscription, User, Account)
2) welcome_cycle_start_date – The date/datetime field that determines the start of your welcome cycle (If you want to send email x days after the start)
3) welcome_cycle_end_date – The date/datetime field that determines the end of the welcome cycle (If you want to send emails x days before the end)

At the top of your welcome_cycle_emails.rb file specify
WelcomeCycle.configure do |c|
  c.base_class = Subscription
  c.welcome_cycle_start_date = :created_at
end


# Sending the email
Set your favourite scheduler to run the WelcomeCycle::Driver.run daily. E.g. everyday at 6am:
0 6 * * * cd /path/to/you/app && rails runner -e production 'WelcomeCycle::Driver.run'