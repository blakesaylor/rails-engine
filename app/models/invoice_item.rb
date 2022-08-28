class InvoiceItem < ApplicationRecord
  validates_presence_of :item_id
  validates_presence_of :invoice_id
  validates_presence_of :quantity
  validates_numericality_of :quantity, only_integer: true
  validates_presence_of :unit_price
  validates_numericality_of :unit_price, only_float: true
  belongs_to :invoice
  belongs_to :item
end
