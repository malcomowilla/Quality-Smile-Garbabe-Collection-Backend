class ServiceProviderSerializer < ActiveModel::Serializer
  attributes :id, :phone_number, :name, :email, :provider_code, :status, :date_registered,  :delivered, :collected,
    :formatted_delivered_date ,:formatted_collected_date, :location,
    :total_delivered_confirmation, :total_collection_confirmation






    def formatted_delivered_date
      object.date_delivered.strftime('%Y-%m-%d %I:%M:%S %p') if object.date_delivered.present?
    end
  
  
  def formatted_collected_date
    object.date_collected.strftime('%Y-%m-%d %I:%M:%S %p') if object.date_collected.present?
  end



  
end


























