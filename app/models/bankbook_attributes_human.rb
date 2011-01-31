class BankbookAttributesHuman < ActiveRecord::Base
  belongs_to :bankbook, :class_name => 'Bankbook', :foreign_key => 'id_bankbook'
  set_table_name "bankbook_attributes_humans"
end