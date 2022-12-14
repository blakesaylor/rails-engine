require 'rails_helper'

describe "Merchants Search" do
  it 'can find the first merchant whose name matches a search, case insensitive' do
    create_list(:merchant, 5)

    expected_merchant = Merchant.third
    wrong_merchant = Merchant.fifth
    wrong_merchant.update(name: expected_merchant.name)

    search_name = expected_merchant.name.upcase

    get "/api/v1/merchants/find?name=#{search_name}"

    expect(response).to be_successful
    expect(response.status).to eq 200

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data].count).to eq 3

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_an(String)
    expect(merchant[:data][:id].to_i).to eq expected_merchant.id

    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to be_an(String)
    expect(merchant[:data][:type]).to eq('merchant')

    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to be_an(Hash)
    expect(merchant[:data][:attributes][:name]).to eq Merchant.find(expected_merchant.id)[:name]
  end

  it 'returns a hash of no data is no objects with a name exist' do
    create_list(:merchant, 5)

    search_name = "I doubt there is an object in the list with this name"

    get "/api/v1/merchants/find?name=#{search_name}"

    expect(response).to be_successful
    expect(response.status).to eq 200

    non_merchant = JSON.parse(response.body, symbolize_names: true)

    expect(non_merchant[:data].count).to eq 0
    expect(non_merchant[:data]).to eq({})
  end

  it 'returns a 400 if no parameter to find is passed in' do
    get "/api/v1/merchants/find"

    expect(response).to_not be_successful
    expect(response.status).to eq 400
  end
  
  it 'returns a 400 if the parameter to find is empty' do
    create_list(:merchant, 5)

    search_name = ''

    get "/api/v1/merchants/find?name=#{search_name}"

    expect(response).to_not be_successful
    expect(response.status).to eq 400
  end

  it 'can find all merchants whose name matches a search, case insensitive' do
    create_list(:merchant, 5)

    search_name = 'BInGo'

    Merchant.third.update(name: search_name.upcase)
    Merchant.fourth.update(name: search_name.downcase)
    Merchant.fifth.update(name: search_name)

    expected_ids = [ Merchant.third.id, Merchant.fourth.id, Merchant.fifth.id ]

    get "/api/v1/merchants/find_all?name=#{search_name}"

    expect(response).to be_successful
    expect(response.status).to eq 200

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq 3

    merchants[:data].each do |merchant_data|
      expect(merchant_data).to have_key(:id)
      expect(merchant_data[:id]).to be_an(String)
      expect(merchant_data[:id].to_i.in?(expected_ids)).to eq true

      expect(merchant_data).to have_key(:type)
      expect(merchant_data[:type]).to be_an(String)
      expect(merchant_data[:type]).to eq('merchant')

      expect(merchant_data[:attributes][:name]).to be_an(String)
      expect(merchant_data[:attributes][:name].downcase.include?(search_name.downcase)).to eq true
    end
  end

  it 'returns an array of no data is no objects with a name exist' do
    create_list(:merchant, 5)

    search_name = "I doubt there is an object in the list with this name"

    get "/api/v1/merchants/find_all?name=#{search_name}"

    expect(response).to be_successful
    expect(response.status).to eq 200

    non_merchant = JSON.parse(response.body, symbolize_names: true)

    expect(non_merchant[:data].count).to eq 0
    expect(non_merchant[:data]).to eq([])
  end

  it 'returns a 400 if no parameter to find is passed in' do
    get "/api/v1/merchants/find_all"

    expect(response).to_not be_successful
    expect(response.status).to eq 400
  end
  
  it 'returns a 400 if the parameter to find is empty' do
    create_list(:merchant, 5)

    search_name = ''

    get "/api/v1/merchants/find_all?name=#{search_name}"

    expect(response).to_not be_successful
    expect(response.status).to eq 400
  end
end