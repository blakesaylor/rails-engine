require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:item_id) }
    it { should validate_presence_of(:invoice_id) }
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).is_a?(Integer) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_a?(Float) }
  end

  describe 'relationships' do
    it { should belong_to(:invoice) }
    it { should belong_to(:item) }
  end

  before :each do

  end

  describe 'class methods' do
    
  end

  describe 'instance methods' do
    
  end
end
