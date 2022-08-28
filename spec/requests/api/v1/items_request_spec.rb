require 'rails_helper'

describe "Items API" do
  it 'sends a list of all Items' do
    create_list(:merchant, 3)

    5.times do 
      create(:item, merchant_id: Merchant.ids.sample)
    end

    get '/api/v1/items'

    expect(response).to be_successful

    all_items = JSON.parse(response.body, symbolize_names: true)

    expect(all_items[:data].count).to eq 5

    all_items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_an(String)
      expect(item[:type]).to eq('item')

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_an(Hash)

      expect(item[:attributes][:name]).to eq Item.find(item[:id])[:name]
      expect(item[:attributes][:name]).to be_an(String)

      expect(item[:attributes][:description]).to eq Item.find(item[:id])[:description]
      expect(item[:attributes][:description]).to be_an(String)

      expect(item[:attributes][:unit_price]).to eq Item.find(item[:id])[:unit_price]
      expect(item[:attributes][:unit_price]).to be_an(Float)

      expect(item[:attributes][:merchant_id]).to eq Item.find(item[:id])[:merchant_id]
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it 'can get one Item by its ID' do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_an(String)

    expect(item[:data]).to have_key(:type)
    expect(item[:data][:type]).to be_an(String)
    expect(item[:data][:type]).to eq('item')

    expect(item[:data]).to have_key(:attributes)
    expect(item[:data][:attributes]).to be_an(Hash)

    expect(item[:data][:attributes][:name]).to eq Item.find(item[:data][:id])[:name]
    expect(item[:data][:attributes][:name]).to be_an(String)

    expect(item[:data][:attributes][:description]).to eq Item.find(item[:data][:id])[:description]
    expect(item[:data][:attributes][:description]).to be_an(String)

    expect(item[:data][:attributes][:unit_price]).to eq Item.find(item[:data][:id])[:unit_price]
    expect(item[:data][:attributes][:unit_price]).to be_an(Float)

    expect(item[:data][:attributes][:merchant_id]).to eq Item.find(item[:data][:id])[:merchant_id]
    expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
  end
end