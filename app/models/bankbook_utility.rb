class BankbookUtility < ActiveRecord::Base
  has_many :counters
  has_many :bankbook_attributes_debts, :class_name => 'BankbookAttributesDebt', :foreign_key => 'id_bankbook_utility'
  has_many :bankbook_attributes_tarifs, :class_name => 'BankbookAttributesTarif', :foreign_key => 'id_bankbook_utility'
  has_many :bankbook_attributes_lgots, :class_name => 'BankbookAttributesLgot', :foreign_key => 'id_bankbook_utility'
  belongs_to :bankbook, :class_name => 'Bankbook', :foreign_key => 'id_bankbook'
  belongs_to :utility, :class_name => 'Utility', :foreign_key => 'code_utility'
end
