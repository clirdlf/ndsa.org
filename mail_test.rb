require 'dotenv'
# require 'mail'
require 'mailjet'

Dotenv.load

Mailjet.configure do |config|
  config.api_key = ENV['MJ_APIKEY_PUBLIC']
  config.secret_key = ENV['MJ_APIKEY_PRIVATE']
  config.default_from = 'info@diglib.org'
end

name = "Wayne Graham, Technical Director"
organization = "CLIR"

text_markup = <<-TEXT
Dear #{name}

We are in the process of renewing memberships and updating contact information for organizational members of the National Digital Stewardship Alliance (NDSA), now proudly hosted by the Digital Library Federation. Soon, the NDSA Coordinating Committee will circulate an important letter about ongoing activities and plans for elections, awards, Digital Preservation 2016, and more—so we’re asking for a minute of your time to help us make sure that letter reaches the right folks.

Currently we have these contacts on record for #{organization}:

*

#{all names/email addresses, with working groups listed}

Please simply reply to this email to let us know whether your information is up to date, and if you would like to add and/or remove any individuals from our records. Your response also affirms #{organization}’s continuing commitment to the NDSA Values Statement (http://ndsa.diglib.org/values/) and to participation as outlined in our Statement of Commitment (http://ndsa.diglib.org/get-involved/). No formal MoU is necessary for continued participation in the National Digital Stewardship Alliance.

In an effort to increase engagement across and within NDSA member organizations, we will also soon be listing each institution’s primary program representative by name on the NDSA members’ list: http://ndsa.diglib.org/members-list/. If you would like to opt out of this listing, please let us know.

Thanks very much for your help! We’re grateful for your time and attention. If you have any questions about the membership renewal process, please let us know.

Warmly,
Oliver Bendorf (on behalf of DLF)

TEXT

html_markup = <<-HTML
<p>Dear #{name},</p>
<p>We are in the process of renewing memberships and updating contact information for organizational members of the National Digital Stewardship Alliance (NDSA), now proudly hosted by the Digital Library Federation. Soon, the NDSA Coordinating Committee will circulate an important letter about ongoing activities and plans for elections, awards, <em>Digital Preservation</em> 2016, and more—so we’re asking for a minute of your time to help us make sure that letter reaches the right folks.</p>
<p>Currently we have these contacts on record for #{organization}:</p>
<p>#{all names/email addresses, with working groups listed}</p>
<p>Please simply <strong>reply to this email</strong> to let us know whether your information is up to date, and if you would like to add and/or remove any individuals from our records. Your response also affirms #{organization}’s continuing commitment to the NDSA Values Statement (<a href="http://ndsa.diglib.org/values/">http://ndsa.diglib.org/values/</a>) and to participation as outlined in our Statement of Commitment (http://ndsa.diglib.org/get-involved/). <strong>No formal MoU is necessary for continued participation in the National Digital Stewardship Alliance</strong>.</p>
<p>In an effort to increase engagement across and within NDSA member organizations, we will also soon be listing each institution’s primary program representative by name on the NDSA members’ list: http://ndsa.diglib.org/members-list/. <strong>If you would like to opt out of this listing, please let us know.</strong> </p>
<p>Thanks very much for your help! We’re grateful for your time and attention. If you have any questions about the membership renewal process, please let us know.</p>
<p>Warmly,<br>Oliver Bendorf (on behalf of DLF)</p>
HTML

mail = Mailjet::Send.create(
  from_email: "ndsa@diglib.org",
  from_name: "National Digital Stewardship Alliance",
  subject: "NDSA Membership Renewal",
  text_part: text_markup,
  html_part: html_markup,
  recipients: [{ :email => 'wgraham@clir.org'}]
)

puts mail.attributes['Sent']
