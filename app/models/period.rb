class Period < ActiveRecord::Base
  has_many :orders
  has_many :bankbook_attributes_debts, :class_name => 'BankbookAttributesDebt', :foreign_key => 'id_period'
end
