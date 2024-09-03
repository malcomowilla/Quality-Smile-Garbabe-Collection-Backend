class S3Uploader < ApplicationRecord
  # require 'aws-sdk-s3'
  # def initialize
  #   @s3_client = Aws::S3::Client.new(
  #     region: 'eu-north-1',
  #     access_key_id: ENV['AWS_ACCESS_KEY'],
  #     secret_access_key: ENV['AWS_SECRET_KEY']
  #   )
  # end
 
  # def upload(file, bucket, key)
  #   @s3_client.put_object(
  #     bucket: bucket,
  #     key: key,
  #     body: file,
  #     acl: 'public-read' # This makes the file publicly accessible
  #   )
    
  #   # Generate the public URL for the uploaded file
  #   "https://#{bucket}.s3.eu-north-1.amazonaws.com/#{key}"
  # end
end
