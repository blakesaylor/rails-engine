class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items
  has_many :invoices

  def self.find_all(name)
    where('name ILIKE ?', "%#{name}%")
  end

  def self.find_one(name)
    find_by('name ILIKE ?', "%#{name}%")
  end
end
