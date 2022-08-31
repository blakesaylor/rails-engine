require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_a?(Float) }
    it { should validate_presence_of(:merchant_id) }
  end

  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
  end

  before :each do

  end

  describe 'class methods' do
    describe '#find_one' do
      it 'can find the first instance that matches a search' do
        merchant_id = create(:merchant).id
        create_list(:item, 5, merchant_id: merchant_id)

        Item.first.update(name: 'no')
        Item.second.update(name: 'no')
        expected_item = Item.third
        Item.fourth.update(name: 'no')
        wrong_item = Item.fifth
        wrong_item.update(name: expected_item.name)

        search_name = expected_item.name.upcase

        expect(Item.find_one(search_name).id).to eq expected_item.id
        expect(Item.find_one(search_name).id).to_not eq wrong_item.id
      end

      it 'returns nil if no objects match the search' do
        merchant_id = create(:merchant).id
        create_list(:item, 5, merchant_id: merchant_id)

        search_name = "I doubt there is an object in the list with this name"

        expect(Item.find_one(search_name)).to eq nil
      end
    end

    describe '#find_all' do
      it 'can find all items containing a search string, case insensitive' do
        merchant_id = create(:merchant).id
        create_list(:item, 5, merchant_id: merchant_id)

        search_name = 'RiNg'

        Item.first.update(name: search_name.upcase)
        Item.second.update(name: 'nope')
        Item.third.update(name: search_name.downcase)
        Item.fourth.update(name: 'wrong')
        Item.fifth.update(name: search_name)

        expect(Item.find_all(search_name).count).to eq 3
      end

      it 'returns an array of empty data if names match the search name' do
        merchant_id = create(:merchant).id
        create_list(:item, 5, merchant_id: merchant_id)

        search_name = 'This is a long string that will test the method'

        expect(Item.find_all(search_name)).to eq([]) 
      end
    end
  end

  describe 'instance methods' do
    
  end
end
