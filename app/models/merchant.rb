class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items
  has_many :invoices

  def self.find_all_by_name(name)
    where('name ILIKE ?', "%#{name}%")
  end

  def self.find_one_by_name(name)
    find_by('name ILIKE ?', "%#{name}%")
  end
end
