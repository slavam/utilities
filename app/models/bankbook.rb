class Bankbook < ActiveRecord::Base
  belongs_to :human, :class_name => 'Human', :foreign_key => 'id_human'
  belongs_to :payer, :class_name => 'Payer', :foreign_key => 'id_human'
  belongs_to :firm, :class_name => 'Firm', :foreign_key => 'code_firm'
  has_many :bankbook_utilities, :class_name => 'BankbookUtility', :foreign_key => 'id_bankbook'
  has_many :utilities, :through => :bankbook_utilities
  has_many :bankbook_attributes_humans, :class_name => 'BankbookAttributesHuman', :foreign_key => 'id_bankbook'
  has_many :bankbook_attributes_rooms, :class_name => 'BankbookAttributesRoom', :foreign_key => 'id_bankbook'
end
