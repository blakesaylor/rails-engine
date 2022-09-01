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
      it 'can find the first instance that matches a search' do
        create_list(:merchant, 5)

        Merchant.first.update(name: 'no')
        Merchant.second.update(name: 'no')
        expected_merchant = Merchant.third
        Merchant.fourth.update(name: 'no')
        wrong_merchant = Merchant.fifth
        wrong_merchant.update(name: expected_merchant.name)

        search_name = expected_merchant.name.upcase

        expect(Merchant.find_one_by_name(search_name).id).to eq expected_merchant.id
        expect(Merchant.find_one_by_name(search_name).id).to_not eq wrong_merchant.id
      end

      it 'returns nil if no objects match the search' do
        create_list(:merchant, 5)

        search_name = "I doubt there is an object in the list with this name"

        expect(Merchant.find_one_by_name(search_name)).to eq nil
      end
    end

    describe '#find_all' do
      it 'can find all instance that match a search string' do
        create_list(:merchant, 5)

        search_name = "PiCKlE AnD ONioN"

        Merchant.first.update(name: 'no')
        Merchant.second.update(name: search_name)
        Merchant.third.update(name: search_name.upcase)
        Merchant.fourth.update(name: 'no')
        Merchant.fifth.update(name: search_name.downcase)

        merchant_ids = [ Merchant.second.id, Merchant.third.id, Merchant.fifth.id ]

        expect(Merchant.find_all_by_name(search_name).count).to eq 3

        Merchant.find_all_by_name(search_name).each do |merchant|
          expect(merchant_ids.include?(merchant.id)).to eq true
        end
      end

      it 'returns an array of empty data if names match the search name' do
        create_list(:merchant, 5)

        search_name = 'This is a long string that will test the method'

        expect(Merchant.find_all_by_name(search_name)).to eq([]) 
      end
    end
  end

  describe 'instance methods' do
    
  end
end
