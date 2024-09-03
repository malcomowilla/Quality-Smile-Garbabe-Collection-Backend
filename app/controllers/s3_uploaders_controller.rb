class S3UploadersController < ApplicationController
  require 'aws-sdk-s3'


  def create
    s3 = Aws::S3::Client.new(
      region: 'eu-north-1',
      access_key_id: ENV['AWS_ACCESS_KEY'],
      secret_access_key: ENV['AWS_SECRET_KEY']
    )
    bucket = 'quality-smiles-bucket'
    file = File.open(Rails.root.join('logo-small.png'))

    # key = "uploads/#{SecureRandom.uuid}/#{params[:image].original_filename}" # Generate a unique key
  
    key = "uploads/#{Date.today}/image_#{SecureRandom.uuid}.png"

    # Upload the file to S3a
    s3.put_object(bucket: bucket, key: key, body: file ,
    acl: 'public-read',
    content_type: 'image/png' 
    )
    
    # Close the file after upload
    file.close
    public_url = "https://#{bucket}.s3.#{s3.config.region}.amazonaws.com/#{key}"

    # Save the public URL to your database or use it as needed
     puts "Public URL: #{public_url}"

    render json: { url: public_url }, status: :created




  end
end
