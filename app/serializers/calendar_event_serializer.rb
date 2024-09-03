class CalendarEventSerializer < ActiveModel::Serializer
  attributes :id, 
  :start, :end, :title
end
