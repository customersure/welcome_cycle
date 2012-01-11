# welcome_cycle

`welcome_cycle` is a gem to send out a cycle of emails when a
customer signs up for a SaaS product.

## Install
	rails generate welcome_cycle:install

Creates:
config/initializers/welcome_cycle.rb
app/mailers/welcome_cycle_mailer.rb

## Config

	WelcomeCycle.configure do |c|
  		c.base_class = Subscription
  		c.welcome_cycle_start_date = :trial_started_at
  		c.welcome_cycle_end_date = :trial_ends_at
	end

1. base_class – The model in your app to query for email recipients (E.g Organisation, Subscription, User, Account)
2. welcome_cycle_start_date – The date/datetime field that determines the start of your welcome cycle (If you want to send email 'n' days after the start)
3. welcome_cycle_end_date – The date/datetime field that determines the end of the welcome cycle (If you want to send emails 'n' days before the end)

The configure block can be specified at the top of your welcome_cycle.rb file.


## Defining new emails

	rails generate welcome_cycle:email name_for_your_email_here

The above generator will add your email to welcome_cycle.rb and create the mailer method and corresponding templates.


### Options for each email
1. days (mandatory) – The days on which you would like the email to be sent
	* positive numbers: Number of days after the welcome cycle begins
	* negative number: Number of days before the welcome cycle ends 
2. scope (optional) – Arel chain that allows you restrict the recipients to any conditions you like

Please note: You must specify days, even if it's only one day. If you leave days blank or miss it out the email will never be sent.

Examples:

	WelcomeCycle::Email.new("We miss you") do
		days 7, 14, 21
		scope do
			where('last_login = ?', nil)
	  	end
	end

	WelcomeCycle::Email.new("Trial ends soon") do
		days -5
	end


## Sending the emails
Set your favourite scheduler to run the WelcomeCycle::Driver.run daily. E.g. using CRON to send them everyday at 6am:

	0 6 * * * cd /path/to/you/app && rails runner -e production 'WelcomeCycle::Driver.run'
	
