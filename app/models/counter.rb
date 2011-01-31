class Counter < ActiveRecord::Base
  has_many :counter_readings
  belongs_to :bankbook_utility
  belongs_to :counter_type
end
