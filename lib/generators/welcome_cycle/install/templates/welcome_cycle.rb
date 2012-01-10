# List your welcome cycle mails here as follows:

# WelcomeCycle::Email.new("Tab code for website") do
#   days 1, 5, 15, -5  # negative days are counted backwards from the trial end
#   scope do
#     where('created_at < ?', Date.today) # send if these Arel conditions are met
#   end
# end