class BankbookAttributesDebt < ActiveRecord::Base
  belongs_to :bankbook_utility, :class_name => 'BankbookUtility', :foreign_key => 'id_bankbook_utility'
  set_table_name "bankbook_attributes_debts"
end