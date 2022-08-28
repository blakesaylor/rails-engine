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
end