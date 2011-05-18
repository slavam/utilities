class Utility < ActiveRecord::Base
  has_many :bankbook_utilities
  belongs_to :utility_type, :class_name => 'UtilityType', :foreign_key => 'id_type'
  set_primary_key "code"
end
