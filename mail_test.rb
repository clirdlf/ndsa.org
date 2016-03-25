require 'dotenv'
require 'mail'
require 'mailjet'

Dotenv.load

Mailjet.configure do |config|
  config.api_key = ENV['MJ_APIKEY_PUBLIC']
  config.secret_key = ENV['MJ_APIKEY_PRIVATE']
  config.default_from = 'info@diglib.org'
end

variable = Mailjet::Send.create(
  from_email: "info@diglib.org",
  from_name: "NDSA",
  subject: "Test email using Mailjet",
  text_part: "This is just a test",
  html_part: "This is just a test",
  recipients: [{ :email => 'wgraham@clir.org'}]
)

puts variable.attributes['Sent']
