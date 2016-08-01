#! /usr/bin/env ruby

require 'colorize'
require 'dotenv'
#require 'google/api_client'
require 'google_drive'
#require 'mailjet'
require 'mail'

Dotenv.load

Mail.defaults do
  delivery_method :smtp, address: "localhost", port: 1025
end

#Mail.defaults do
  #delivery_method :smtp,
    #address:  "smtp.office365.com",
    #port:      "587",
    #authentication: :login,
    #user_name: ENV['SMTP_USERNAME'],
    #password:  ENV['SMTP_PASSWORD'],
    #domain:   'clir.org',
    #enable_starttls_auto: true
#end


# Configuration
# Mailjet.configure do |config|
#   config.api_key      = ENV['MJ_APIKEY_PUBLIC']
#   config.secret_key   = ENV['MJ_APIKEY_PRIVATE']
#   config.default_from = 'ndsa@diglib.org'
# end

# Methods
def parse_name(name)
    parts = name.split(' ')
    first_name = parts[0]

    first_name = parts[1] if parts[0] == 'Dr.' || parts[0] == 'W.'

    first_name
end

def email_hash(primary, names)
    recipients = []
    recipients << { email: primary }
    names.each do |name|
        recipients << { email: name[:email] }
    end
    recipients
end

def split_emails(names)
    emails = ""
    names.each do |name|
        emails += "#{name[:email]}," unless name[:email] == "" || name[:email] == "x"
    end
    emails
end

def format_names_txt(names)
    txt = ''
    names.each do |name|
        txt += "#{name[:name]}: " unless name[:name] == ''
        txt += (name[:email])  unless name[:email] == '' || name[:email] == 'x'
        txt += "Email not available" if name[:email] == 'x'
    end

    txt
end

def format_names_html(primary, names)
    html = '<ul>'
    html += "<li>#{primary}</li>"
    if names.size > 0
        names.each do |name|
            html += '<li>'
            html += "#{name[:name]}: " unless name[:name] == ''
            html += (name[:email]) unless name[:email] == '' || name[:email] == 'x'
            html += "Email not available" if name[:email] == 'x'
            html += '</li>'
        end
    end
    html += '</ul>'
end

def format_cc_names(names)
    cc_names = ""
    names.each do |name|
        cc_names += "#{name[:name]}" unless name[:name] == ""

        if(names.size > 0 && name[:name] != "")
            cc_names += ", "
        end
    end
    "Cc: #{cc_names.chop.chop}" unless names.size == 0
end

def text_markup(primary_contact, organization, secondary_contacts)
    markup = <<-TEXT
Dear #{parse_name(primary_contact)},

This summer the National Digital Stewardship Alliance turns its attention to leadership renewal. We gratefully thank our outgoing working group chairs and Coordinating Committee members for their service across the transition period to our new home at the Digital Library Federation.

Members of the NDSA Coordinating Committee serve staggered three year terms and five members will have completed their terms, retiring as of the Fall meeting. We thank Jonathan Crabtree, Meg Phillips, John Spencer, Helen Tibbo, and Kate Wittenberg for their many contributions.

Following a public call for nominations, we are presenting a slate of five candidates to join the Coordinating Committee, and ask that you affirm and endorse them by vote.

* Bradley Daigle, Partnerships/Content Lead, APTrust
* Carol Kussman, Digital Preservation Analyst, U of Minnesota Libraries
* Mary Molinaro, Chief Operating Officer &amp; Services Manager, DPN
* Gabby Redwine, Digital Archivist at Yale
* Helen Tibbo, Alumni Distinguished Professor, SLIS, UNC-Chapel Hill

Your organization can cast its vote at https://www.surveymonkey.com/r/BQQQ6RJ between August 1 and August 15. Vote for any or all candidates you would like to see as CC members. Candidate statements can be found at https://www.diglib.org/?p=12333.

As a reminder, only one ballot may be cast per member organization. NDSA's recorded program representative or a designated proxy of each member organization is asked to submit your organization's vote.

Thank you for your participation,

The NDSA Coordinating Committee

#{format_cc_names(secondary_contacts)}

    TEXT
    markup
end

def html_markup(primary_contact, organization, secondary_contacts)
    markup = <<-HTML
<p>Dear #{parse_name(primary_contact)},</p>

<p>This summer the National Digital Stewardship Alliance turns its attention to leadership renewal. We gratefully thank our outgoing working group chairs and Coordinating Committee members for their service across the transition period to our new home at the Digital Library Federation.</p>

<p>Members of the NDSA Coordinating Committee serve staggered three year terms and five members will have completed their terms, retiring as of the Fall meeting. We thank Jonathan Crabtree, Meg Phillips, John Spencer, Helen Tibbo, and Kate Wittenberg for their many contributions.</p>

<p>Following a public call for nominations, we are presenting a slate of five candidates to join the Coordinating Committee, and ask that you affirm and endorse them by vote.</p>

<ul>
<li>Bradley Daigle, Partnerships/Content Lead, APTrust</li>
<li>Carol Kussman, Digital Preservation Analyst, U of Minnesota Libraries</li>
<li>Mary Molinaro, Chief Operating Officer &amp; Services Manager, DPN</li>
<li>Gabby Redwine, Digital Archivist at Yale</li>
<li>Helen Tibbo, Alumni Distinguished Professor, SLIS, UNC-Chapel Hill</li>
</ul>

<p>Your organization can cast its vote at <a href="https://www.surveymonkey.com/r/BQQQ6RJ">https://www.surveymonkey.com/r/BQQQ6RJ</a> between August 1 and August 15. Vote for any or all candidates you would like to see as CC members. Candidate statements can be found at <a href="https://www.diglib.org/?p=12333">https://www.diglib.org/?p=12333</a>.</p>

<p>As a reminder, only one ballot may be cast per member organization. NDSA’s recorded program representative or a designated proxy of each member organization is asked to submit your organization's vote.</p>

<p>Thank you for your participation,</p>

The NDSA Coordinating Committee<p>#{format_cc_names(secondary_contacts)}</p>
HTML
markup
end

# Authorize
session = GoogleDrive.saved_session('config.json')

# get the spreadsheet
ws = session.spreadsheet_by_key('1J2wFfkKxxRbDJLUdH5k-ILm12zLuJpgWoRh21dJ2O84').worksheets[0]

(2..ws.num_rows).each do |row|
    active = ws[row, 30]
    election = ws[row, 35]

    next unless active == 'TRUE' && election != 'TRUE'
    organization   = ws[row, 2]

    contact1_name  = ws[row, 8]
    contact1_email = ws[row, 10]

    contact2_name  = ws[row, 14]
    contact2_email = ws[row, 16]

    contact3_name  = ws[row, 17]
    contact3_email = ws[row, 19]

    additional_contacts = [
        contact2_email,
        contact3_email
    ].reject(&:empty?).reject { |value| value == contact1_email }

    additional_contacts.uniq!

    names = []

    puts "Sending email to #{organization}".blue
    if(additional_contacts.size > 0)
        contact2 = { :name => contact2_name, :email => contact2_email }
        names << contact2 if additional_contacts.include?(contact2[:email])

        contact3 = { name: contact3_name, email: contact3_email }

        if(additional_contacts.include? contact3[:email])
          names << contact3 unless contact3 === contact2
        end
    end

    puts "#{contact1_name} #{contact1_email} | #{additional_contacts}".green

    mail = Mail.new do
      from 'ndsa-elections@diglib.org'
      to contact1_email
      cc additional_contacts
      subject "2016 NDSA Coordinating Committee Election"

      text_part do
        body text_markup(contact1_name, organization, names)
      end

      html_part do
        content_type 'text/html; charset=UTF-8'
        body html_markup(contact1_name, organization, names)
      end
    end


    mail.deliver!

    #mail = Mailjet::Send.create(
        #from_email: "ndsa@diglib.org",
        #from_name:  "National Digital Stewardship Alliance",
        #subject:    "#{organization} NDSA Membership Renewal",
        #text_part:  text_markup(contact1_name, organization, names),
        #html_part:  html_markup(contact1_name, organization, names),
        #recipients: email_hash(contact1_email, names)
        ## recipients: [{:email => 'wgraham@clir.org'}, {:email => 'obendorf@clir.org'}]
    #)

    #puts mail.attributes['Sent'] # mailjet api only

    #break
end



