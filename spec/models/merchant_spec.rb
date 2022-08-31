require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices) }
  end

  before :each do

  end

  describe 'class methods' do
    describe '#find_one' do
      it 'can find the first instance of a search ' do
        create_list(:merchant, 5)

        Merchant.first.update(name: 'no')
        Merchant.second.update(name: 'no')
        expected_merchant = Merchant.third
        Merchant.fourth.update(name: 'no')
        wrong_merchant = Merchant.fifth
        wrong_merchant.update(name: expected_merchant.name)

        search_name = expected_merchant.name.upcase

        expect(Merchant.find_one(search_name).id).to eq expected_merchant.id
        expect(Merchant.find_one(search_name).id).to_not eq wrong_merchant.id
      end
    end
  end

  describe 'instance methods' do
    
  end
end
