class StoreManagerSerializer < ActiveModel::Serializer
  attributes :id, :number_of_bags_received, :formatted_received_date, :number_of_bags_delivered, 
  :formatted_delivered_date, :name, :email, :phone_number,
  :store_number, :manager_number , :delivered_bags, :received_bags
  


  def formatted_delivered_date
    object.date_delivered.strftime('%Y-%m-%d %I:%M:%S %p') if object.date_delivered.present?
  end


  def formatted_received_date
    object.date_received.strftime('%Y-%m-%d %I:%M:%S %p') if object.date_received.present?
  end

  
end



