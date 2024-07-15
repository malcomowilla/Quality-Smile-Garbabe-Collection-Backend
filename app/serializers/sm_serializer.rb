class SmSerializer < ActiveModel::Serializer
  attributes :id, :user, :message, :status, :formatted_date, :admin_user, :system_user


  def formatted_date
    object.date.strftime('%Y-%m-%d %I:%M:%S %p') if object.date.present?
  end

end









