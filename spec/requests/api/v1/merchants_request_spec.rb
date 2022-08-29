require 'rails_helper'

describe "Merchants API" do
  it 'sends a list of all Merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    all_merchants = JSON.parse(response.body, symbolize_names: true)

    expect(all_merchants[:data].count).to eq 3

    all_merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_an(String)
      expect(merchant[:type]).to eq('merchant')

      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_an(Hash)
      expect(merchant[:attributes][:name]).to eq Merchant.find(merchant[:id])[:name]
    end
  end

  it 'can get one Merchant by its ID' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_an(String)

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to be_an(String)
    expect(merchant[:data][:type]).to eq('merchant')

    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to be_an(Hash)
    expect(merchant[:data][:attributes][:name]).to eq Merchant.find(merchant[:data][:id])[:name]
  end

  # Add test for 404 if merchant ID does not exist
  it 'returns a 404 if a merchant ID does not exist' do
    id = create(:merchant).id
    create_list(:item, 10, merchant_id: id)

    false_id = id + 9000

    get "/api/v1/merchants/#{false_id}"

    output = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq 404

    expect(output).to have_key(:error)
    expect(output[:error]).to eq "There are no merchants with that ID"
  end

  it 'can get all items for a merchant' do
    id = create(:merchant).id
    create_list(:item, 10, merchant_id: id)

    get "/api/v1/merchants/#{id}/items"

    merchant_items = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful

    expect(merchant_items[:data].count).to eq 10

    merchant_items[:data].each do |merchant_item|
      expect(merchant_item).to have_key(:id)
      expect(merchant_item[:id]).to be_an(String)

      expect(merchant_item).to have_key(:type)
      expect(merchant_item[:type]).to be_an(String)
      expect(merchant_item[:type]).to eq('item')

      expect(merchant_item).to have_key(:attributes)
      expect(merchant_item[:attributes]).to be_an(Hash)

      expect(merchant_item[:attributes]).to have_key(:name)
      expect(merchant_item[:attributes][:name]).to be_an(String)

      expect(merchant_item[:attributes]).to have_key(:description)
      expect(merchant_item[:attributes][:description]).to be_an(String)

      expect(merchant_item[:attributes]).to have_key(:unit_price)
      expect(merchant_item[:attributes][:unit_price]).to be_an(Float)

      expect(merchant_item[:attributes]).to have_key(:merchant_id)
      expect(merchant_item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it 'returns a 404 if a merchant ID does not exist (merchant items)' do
    id = create(:merchant).id
    create_list(:item, 10, merchant_id: id)

    false_id = id + 9000

    get "/api/v1/merchants/#{false_id}/items"

    output = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq 404

    expect(output).to have_key(:error)
    expect(output[:error]).to eq "There are no merchants with that ID"
  end
end