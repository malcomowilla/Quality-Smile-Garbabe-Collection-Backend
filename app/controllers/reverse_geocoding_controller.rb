class ReverseGeocodingController < ApplicationController
def address
    require 'opencage/geocoder'

    geocoder = OpenCage::Geocoder.new(api_key: '3e05cce5632e411a9368c5e42416d3c0' )
    
    results = geocoder.geocode('Jeskirona apartment' )
p results.first
    # result = geocoder.reverse_geocode(-1.282738, 37.11304237)
    # p result.address
    # p result.confidence
    render json: results.first
    
end

  
end
