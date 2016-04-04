#! /usr/bin/env ruby

require 'google/api_client'
require 'google_drive'
require 'mail'
require 'colorize'

Mail.defaults do
    delivery_method :smtp, address: 'localhost', port: 1025
end

def parse_name(name)
    parts = name.split(' ')
    first_name = parts[0]

    first_name = parts[1] if parts[0] == 'Dr.' || parts[0] == 'W.'

    first_name
end

def split_emails(names)
    # puts names
    emails = ""
    names.each do |name|
        emails += "#{name[:email]}," unless name[:email] == ""
    end
    emails
end

def format_names_txt(names)
    txt = ''
    names.each do |name|
        txt += "#{name[:name]}: " unless name[:name] == ''
        txt += (name[:email]) unless name[:email] == ''
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
            html += (name[:email]).to_s unless name[:email] == ''
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
            ## TODO remove last ,
            cc_names += ", "
        end
    end
    "Cc: #{cc_names.chop.chop}" unless names.size == 0
end

def text_markup(primary_contact, organization, secondary_contacts)
    markup = <<-TEXT
Dear #{parse_name(primary_contact)},

We are in the process of renewing memberships and updating contact information for organizational members of the National Digital Stewardship Alliance (NDSA), now proudly hosted by the <a href="https://diglib.org">Digital Library Federation</a>. Soon, the NDSA Coordinating Committee will circulate an important letter about ongoing activities and plans for elections, awards, Digital Preservation 2016, and more—so we're asking for a minute of your time to help us make sure that letter reaches the right folks.

Currently we have these contacts on record for #{organization}:

#{primary_contact}
#{format_names_txt secondary_contacts}

Please simply reply to this email to let us know whether your information is up to date, and if you would like to add and/or remove any individuals from our records. Your response also affirms #{organization}'s continuing commitment to the NDSA Values Statement (http://ndsa.diglib.org/values/) and to participation as outlined in our Statement of Commitment (http://ndsa.diglib.org/get-involved/). No formal MoU is necessary for continued participation in the National Digital Stewardship Alliance.

In an effort to increase engagement across and within NDSA member organizations, we will also soon be listing each institution's primary program representative by name on the NDSA members' list: http://ndsa.diglib.org/members-list/. If you would like to opt out of this listing, please let us know.

Thanks very much for your help! We're grateful for your time and attention. If you have any questions about the membership renewal process, please let us know.

Warmly,

Oliver Bendorf (on behalf of DLF)
Program Associate, Digital Library Federation


#{format_cc_names(secondary_contacts)}

    TEXT
end

def html_markup(primary_contact, organization, secondary_contacts)
    markup = <<-HTML
<p>Dear #{parse_name(primary_contact)},</p>

<p>We are in the process of renewing memberships and updating contact information for organizational members of the National Digital Stewardship Alliance (NDSA), now proudly hosted by the Digital Library Federation. Soon, the NDSA Coordinating Committee will circulate an important letter about ongoing activities and plans for elections, awards, Digital Preservation 2016, and more—so we're asking for a minute of your time to help us make sure that letter reaches the right folks.</p>

<p>Currently we have these contacts on record for #{organization}:</p>

#{format_names_html(primary_contact, secondary_contacts)}

<p>Please simply <strong>reply to this email</strong> to let us know whether your information is up to date, and if you would like to add and/or remove any individuals from our records. Your response also affirms #{organization}'s continuing commitment to the <a href="http://ndsa.diglib.org/values/">NDSA Values Statement</a> and to participation as outlined in our <a href="http://ndsa.diglib.org/get-involved/">Statement of Commitment</a>. <strong>No formal MoU is necessary for continued participation in the National Digital Stewardship Alliance</strong>.</p>

<p>In an effort to increase engagement across and within NDSA member organizations, we will also soon be listing each institution's primary program representative by name on the <a href="http://ndsa.diglib.org/members-list/">NDSA members' list</a>. <strong>If you would like to opt out of this listing, please let us know</strong>.</p>

<p>Thanks very much for your help! We're grateful for your time and attention. If you have any questions about the membership renewal process, please let us know.</p>

<p>Warmly,</p>

<p>Oliver Bendorf (on behalf of DLF)<br>
Program Associate, Digital Library Federation
</p>

<p>#{format_cc_names(secondary_contacts)}</p>
HTML
end

session = GoogleDrive.saved_session('config.json')

ws = session.spreadsheet_by_key('1J2wFfkKxxRbDJLUdH5k-ILm12zLuJpgWoRh21dJ2O84').worksheets[0]

(2..ws.num_rows).each do |row|
    active = ws[row, 30]

    next unless active == 'TRUE'
    organization   = ws[row, 2]

    contact1_name  = ws[row, 8]
    contact1_email = ws[row, 10]

    contact2_name  = ws[row, 14]
    contact2_email = ws[row, 16]

    contact3_name  = ws[row, 17]
    contact3_email = ws[row, 19]

    additional_contacts = [
        # contact1_email,
        contact2_email,
        contact3_email
    ].reject(&:empty?).reject { |value| value == contact1_email }

    additional_contacts.uniq!

    names = []

    puts "Sending email to #{organization}".colorize(:blue)
    if(additional_contacts.size > 0)
        contact2 = { :name => contact2_name, :email => contact2_email,  role: 'secondary' }
        # puts "additional_contacts: #{additional_contacts.inspect.colorize(:yellow)}"
        names << contact2 if additional_contacts.include?(contact2[:email])

        contact3 = { name: contact3_name, email: contact3_email, role: 'Tertiary' }
        names << contact3 if additional_contacts.include? contact3[:email]

        # puts "#{contact2_name}  | test: #{additional_contacts.include? contact2[:email]}"
        # puts "#{contact3_name} | test: #{additional_contacts.include? contact2[:email]}"
        # puts "Names: #{contact2}, #{contact3}"
    end





    # puts additional_contacts.size
    # puts parse_name contact1_name
    # puts "#{contact3_name} - #{contact3_email}" if additional_contacts.include?(contact3_email) && contact3_name == ''
    # puts "#{contact2_name} - #{contact2_email}" if (additional_contacts.include?(contact2_email) && contact2_name == "")
    # puts "#{organization} | #{contact1_email}" if contact1_name.length == 0
    # puts "#{contact1_email}: additional contacts: #{additional_contacts}"

    mail = Mail.new do
        from 'National Digital Stewardship Alliance <ndsa@diglib.org>'
        to contact1_email
        cc "#{split_emails names}"
        #   to "#{contacts.uniq.each {|email| "#{email}," }}"
        subject "#{organization} NDSA Membership Renewal"

        text_part do
            content_type 'text/plain; charset=UTF-8'
            body text_markup(contact1_name, organization, names)
        end

        html_part do
            content_type 'text/html; charset=UTF-8'
            body html_markup(contact1_name, organization, names)
        end
    end
    mail.deliver
    # break
end
