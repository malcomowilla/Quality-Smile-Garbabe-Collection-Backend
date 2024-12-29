encoded_credentials = ENV['FIREBASE_CREDENTIALS_BASE64']&.delete("\n")
raise "FIREBASE_CREDENTIALS_BASE64 is not set or invalid" unless encoded_credentials

# scopes = ['https://www.googleapis.com/auth/firebase.messaging']
scopes = ['https://www.googleapis.com/auth/firebase.messaging']
credentials_data = Base64.decode64(encoded_credentials)
json_key_io = StringIO.new(credentials_data)
# Load the credentials
credentials = Google::Auth::ServiceAccountCredentials.make_creds(

  json_key_io: json_key_io,
  scope: scopes
)