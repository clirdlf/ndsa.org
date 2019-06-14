##
# Wrapper for Google related items
module Google
  def self.session
    GoogleDrive.saved_session('config.json')
  end

  def self.worksheet
    session.spreadsheet_by_key(ENV['SPREADSHEET_KEY']).worksheets[0]
  end

  def self.login
    system('clear') # clear the screen
    puts 'Authorizing...'.green
    worksheet
  end
end
