class Bankunit < ActiveRecord::Base
  has_many :filials
  belongs_to :city
end
