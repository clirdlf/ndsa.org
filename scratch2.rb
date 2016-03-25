require 'google/api_client'
require 'google_drive'
require 'mail'

Mail.defaults do
  delivery_method :smtp, address: "localhost", port: 1025
end


session = GoogleDrive.saved_session('config.json')

ws = session.spreadsheet_by_key('1J2wFfkKxxRbDJLUdH5k-ILm12zLuJpgWoRh21dJ2O84').worksheets[0]

(2..ws.num_rows).each do |row|
  organization   = ws[row, 2]
  contact1_email = ws[row, 10]
  contact2_email = ws[row, 16]
  contact3_email = ws[row, 19]

  additional_contacts = [
    # contact1_email,
    contact2_email,
    contact3_email
  ].reject(&:empty?).reject{|value| value == contact1_email }

  additional_contacts.uniq!

  puts "#{contact1_email}: additional contacts: #{additional_contacts}"

  # mail = Mail.new do
  #   from 'info@diglib.org'
  #   to "#{contacts.uniq.each {|email| "#{email}," }}"
  #   subject "#{organization} NDSA Membership"
  #
  #   text_part do
  #     body 'This is the plain text part of the message'
  #   end
  #
  #   html_part do
  #     content_type 'text/html; charset=UTF-8'
  #     body '<h1>This is the HTML part of the message</h1>'
  #   end
  # end
  #
  # mail.deliver

  # break
end


#mail = Mail.new do
  #from 'info@diglib.org'
  #to 'wgraham@clir.org'
  #subject 'test email'

  #text_part do
    #body 'Plain text message'
  #end

  #html_part do
    #content_type 'text/html; charset=UTF-8'
    #body '<h1>This is the HTML</h1>'
  #end

#end

#mail.deliver
