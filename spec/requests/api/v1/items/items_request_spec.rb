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

  it 'returns a 404 if an item ID does not exist' do
    merchant_id = create(:merchant).id
    item_id = create(:item, merchant_id: merchant_id).id

    false_id = item_id + 9000

    get "/api/v1/items/#{false_id}"

    output = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq 404

    expect(output).to have_key(:error)
    expect(output[:error]).to eq "There are no items with that ID"
  end

  it "can create a new item" do
    merchant = create(:merchant)
    item_params = ({
                    name: Faker::Food.dish,
                    description: Faker::Food.description,
                    unit_price: Faker::Number.decimal(r_digits: 2),
                    merchant_id: merchant.id
                  })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq 201

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

    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it "renders a 404 if an item can't be created" do
    merchant = create(:merchant)
    item_params = ({
                    name: Faker::Food.dish,
                    description: Faker::Food.description,
                    unit_price: Faker::Food.dish,
                    merchant_id: merchant.id
                  })

    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    expect(response).to_not be_successful
    expect(response.status).to eq 404
  end

  it "can update an existing item" do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id

    previous_name = Item.last.name

    updated_name = Faker::Food.dish

    item_params = { name: updated_name }

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq(updated_name)
  end

  it "renders a 404 if a merchant ID doesn't exist when updating" do
    merchant = create(:merchant)
    id = create(:item, merchant_id: merchant.id).id

    previous_name = Item.last.name

    updated_name = Faker::Food.dish

    item_params = { name: updated_name,
                    merchant_id: merchant.id + 9000 }

    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})

    expect(response).to_not be_successful
    expect(response.status).to eq 404
    expect(response.body).to eq " "
  end

  it "can destroy an item" do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(response.status).to eq 204
    # expect(response.body).to eq nil
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "returns a 404 if an item id to be deleted doesn't exist" do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    false_id = item.id + 9000

    delete "/api/v1/items/#{false_id}"

    expect(response).to_not be_successful
    expect(response.status).to eq 404
  end

  it "can return the merchant for a given item" do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)
    
    get "/api/v1/items/#{item.id}/merchant"

    merchant_output = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq 200

    expect(merchant_output).to have_key(:data)

    expect(merchant_output[:data]).to have_key(:id)
    expect(merchant_output[:data][:id]).to be_an(String)
    expect(merchant_output[:data][:id]).to eq merchant.id.to_s

    expect(merchant_output[:data]).to have_key(:type)
    expect(merchant_output[:data][:type]).to be_an(String)
    expect(merchant_output[:data][:type]).to eq 'merchant'

    expect(merchant_output[:data]).to have_key(:attributes)
    expect(merchant_output[:data][:attributes]).to be_an(Hash)

    expect(merchant_output[:data][:attributes]).to have_key(:name)
    expect(merchant_output[:data][:attributes][:name]).to be_an(String)
    expect(merchant_output[:data][:attributes][:name]).to eq merchant.name
  end

  it 'returns a 404 if an item is not found (item merchant)' do
    id = create(:merchant).id
    create_list(:item, 10, merchant_id: id)

    false_id = id + 9000

    get "/api/v1/items/#{false_id}/merchant"

    output = JSON.parse(response.body, symbolize_names: true)

    expect(response).to_not be_successful
    expect(response.status).to eq 404

    expect(output).to have_key(:error)
    expect(output[:error]).to eq "There are no items with that ID"
  end
end