#! /usr/bin/env ruby

require 'colorize'
require 'dotenv'
require 'google_drive'
require 'mail'

Dotenv.load

Mail.defaults do
  delivery_method :smtp,
    address:  "smtp.office365.com",
    port:      "587",
    authentication: :login,
    user_name: ENV['SMTP_USERNAME'],
    password:  ENV['SMTP_PASSWORD'],
    domain:   'clir.org',
    enable_starttls_auto: true
end

mail = Mail.new do
  from     ENV['SMTP_USERNAME']
  to       'wayne.graham@gmail.com'
  cc       'katherineee@gmail.com'
  subject  'Test for NDSA to external email'
  body     'Some text'
end

mail.deliver!
