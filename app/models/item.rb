class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_numericality_of :unit_price, only_float: true
  validates_presence_of :merchant_id
  belongs_to :merchant
  has_many :invoice_items

  def self.find_all(name)
    where('name ILIKE ?', "%#{name}%")
  end

  def self.find_one(name)
    find_by('name ILIKE ?', "%#{name}%")
  end
end
