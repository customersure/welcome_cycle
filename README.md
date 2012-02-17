# welcome_cycle

`welcome_cycle` is a ruby gem to help you send out a cycle of emails. Specifically when new users sign up to your app.

## Gemfile
	gem 'welcome_cycle'
	bundle install

## Install
	rails generate welcome_cycle:install

**Creates:**

`config/initializers/welcome_cycle.rb` - Defines config and your emails.

`app/mailers/welcome_cycle_mailer.rb` - Mailer methods for each email, each one is passed the recipient object.

## Config

The configure block should be specified at the top of `welcome_cycle.rb`

	WelcomeCycle.configure do |c|
  		c.base_class = Subscription
  		c.welcome_cycle_start_date = :trial_started_at
  		c.welcome_cycle_end_date = :trial_ends_at
  		c.before { run_something_special }
  		c.after { run_something_special }
	end

**base_class** - The base model in your app to query for email recipients. (E.g Organisation, Subscription, User, Account, etc.)

**welcome_cycle_start_date** - The date/datetime field that determines the start of your welcome cycle. (If you want to send email 'n' days after the start.)

**welcome_cycle_end_date** - The date/datetime field that determines the end of the welcome cycle. (If you want to send emails 'n' days around the end.)

**before** - An optional callback to run before all emails are sent.

**after** - An optional callback to run after all emails are sent.


## Defining new emails

	rails generate welcome_cycle:email name_for_your_email_here

The above generator will add an email definition to `welcome_cycle.rb`, add the mailer method to `welcome_cycle_mailer.rb` and create the corresponding text and html erb templates.

### Options for each email

**days_into_cycle** – The days on which you would like the email to be sent after signing up. E.g.: 3 = Three days after the sign up.

**days_offset_from_cycle_end** - The days on which you like the email to go out around the cycle/trial end.

* positive numbers: Number of days *before* the welcome cycle ends.
* negative number: Number of days *after* the welcome cycle ends.

**scope** - An optional arel chain that allows you restrict the recipients to any conditions you like.

* With some simple conditions you can easily set up email variations. E.g. have they performed a certain task? Have they subscribed? Etc.

You **must** specify days_into_cycle or days_offset_from_cycle_end.

### Example email definitions:

	WelcomeCycle::Email.new("We miss you") do
		days 7, 14, 21
		scope do
			where('last_login = ?', nil)
		end
	end

	WelcomeCycle::Email.new("Trial ends soon!") do
		days -5
		scope do
			where(:subscribed_at => false)
		end
	end

##

## Sending the emails
Set your favourite scheduler to run the WelcomeCycle::Driver.run daily. E.g. using CRON to send them everyday at 6am:

	0 6 * * * cd /path/to/you/app && rails runner -e production 'WelcomeCycle::Driver.run'

## Notes
1. The email templates and corresponding methods live inside your app.
2. Ironically welcome_cycle is not designed to send an actual welcome_email! You probably want do that immediately when people sign-up. Feel free to use the provided mailer class.
3. We'll try our best to stick to semantic versioning (http://semver.org/)

## TODO
 * Work out a clean way of ignoring the initializer unless rails runner is being used.

## License

welcome_cycle is released under the MIT license:

* www.opensource.org/licenses/MIT
