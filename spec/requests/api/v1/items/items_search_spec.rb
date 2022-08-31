require 'rails_helper'

describe "Items Search" do
  it 'can find all items whose name matches a search, case insensitive' do
    merchant_id = create(:merchant).id
    create_list(:item, 5, merchant_id: merchant_id)

    search_name = 'RiNg'

    Item.first.update(name: search_name.upcase)
    Item.second.update(name: 'nope')
    Item.third.update(name: search_name.downcase)
    Item.fourth.update(name: 'wrong')
    Item.fifth.update(name: search_name)

    expected_ids = [ Item.first.id, Item.third.id, Item.fifth.id ]

    get "/api/v1/items/find_all?name=#{search_name}"

    expect(response).to be_successful
    expect(response.status).to eq 200

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq 3

    items[:data].each do |item_data|
      expect(item_data).to have_key(:id)
      expect(item_data[:id]).to be_an(String)
      expect(item_data[:id].to_i.in?(expected_ids)).to eq true

      expect(item_data).to have_key(:type)
      expect(item_data[:type]).to be_an(String)
      expect(item_data[:type]).to eq('item')

      expect(item_data).to have_key(:attributes)
      expect(item_data[:attributes]).to be_an(Hash)
      expect(item_data[:attributes].count).to eq 4

      expect(item_data[:attributes][:name]).to be_an(String)
      expect(item_data[:attributes][:name].downcase.include?(search_name.downcase)).to eq true

      expect(item_data[:attributes][:description]).to be_an(String)
      expect(item_data[:attributes][:unit_price]).to be_an(Float)
      expect(item_data[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it 'returns an array of no data is no objects with a name exist' do
    merchant_id = create(:merchant).id
    create_list(:item, 5, merchant_id: merchant_id)

    search_name = "I doubt there is an object in the list with this name"

    get "/api/v1/items/find_all?name=#{search_name}"

    expect(response).to be_successful
    expect(response.status).to eq 200

    non_item = JSON.parse(response.body, symbolize_names: true)

    expect(non_item[:data].count).to eq 0
    expect(non_item[:data]).to eq([])
  end

  it 'returns a 400 if no parameter to find is passed in' do
    get "/api/v1/items/find_all"

    expect(response).to_not be_successful
    expect(response.status).to eq 400
  end
  
  it 'returns a 400 if the parameter to find is empty' do
    merchant_id = create(:merchant).id
    create_list(:item, 5, merchant_id: merchant_id)

    search_name = ''

    get "/api/v1/items/find_all?name=#{search_name}"

    expect(response).to_not be_successful
    expect(response.status).to eq 400
  end
end