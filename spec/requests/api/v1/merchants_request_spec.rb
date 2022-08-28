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
end