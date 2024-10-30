class MyCalendarSetting < ApplicationRecord

  acts_as_tenant(:account)
  
end
