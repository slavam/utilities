class Firm < ActiveRecord::Base
  has_many :bankbooks
  set_primary_key "code"
end
