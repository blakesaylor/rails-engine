class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  validates_numericality_of :unit_price, only_float: true
  validates_presence_of :merchant_id
  belongs_to :merchant
  has_many :invoice_items

  def self.find_all_by_name(name)
    where('name ILIKE ?', "%#{name}%")
  end

  def self.find_one_by_name(name)
    find_by('name ILIKE ?', "%#{name}%")
  end

  def self.find_all_by_price(min = 0, max=Float::INFINITY)
    where("unit_price >= ? AND unit_price <= ?", min.to_f, max.to_f).order(:name)
  end 

  def self.find_one_by_price(min = 0, max = Float::INFINITY)
    where("unit_price >= ? AND unit_price <= ?", min.to_f, max.to_f).order(:name).first
  end 
end
