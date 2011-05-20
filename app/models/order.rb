class Order < ActiveRecord::Base
  belongs_to :order_state
#  belongs_to :human, :class_name => 'Human', :foreign_key => 'human_id'
  belongs_to :payer, :class_name => 'Payer', :foreign_key => 'human_id'
  belongs_to :period
  
  has_many :order_items
end
