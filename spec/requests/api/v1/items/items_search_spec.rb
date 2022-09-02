require 'rails_helper'

describe "Items Search" do
  describe '#find' do
    it 'can find the first merchant whose name matches a search, case insensitive' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      Item.first.update(name: 'no')
      Item.second.update(name: 'no')
      expected_item = Item.third
      Item.fourth.update(name: 'no')
      Item.fifth.update(name: expected_item.name)
      wrong_item = Item.fifth

      search_name = expected_item.name.upcase

      get "/api/v1/items/find?name=#{search_name}"

      expect(response).to be_successful
      expect(response.status).to eq 200

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:data].count).to eq 3

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_an(String)
      expect(item[:data][:id].to_i).to eq expected_item.id

      expect(item[:data]).to have_key(:type)
      expect(item[:data][:type]).to be_an(String)
      expect(item[:data][:type]).to eq('item')

      expect(item[:data]).to have_key(:attributes)
      expect(item[:data][:attributes]).to be_an(Hash)
      expect(item[:data][:attributes][:name]).to eq Item.find(expected_item.id)[:name]
    end

    it 'returns a hash of no data is no objects with a name exist' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      search_name = "I doubt there is an object in the list with this name"

      get "/api/v1/items/find?name=#{search_name}"

      expect(response).to be_successful
      expect(response.status).to eq 200

      non_item = JSON.parse(response.body, symbolize_names: true)

      expect(non_item[:data].count).to eq 0
      expect(non_item[:data]).to eq({})
    end

    it 'can find an item by minimum price' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      Item.first.update(unit_price: 20)
      Item.second.update(unit_price: 100)
      Item.third.update(unit_price: 75)
      Item.fourth.update(unit_price: 150)
      Item.fifth.update(unit_price: 900)

      minimum_price = Item.fifth.unit_price - 1

      get "/api/v1/items/find?min_price=#{minimum_price}"

      expect(response).to be_successful
      expect(response.status).to eq 200

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item).to have_key(:data)

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_an(String)

      expect(item[:data]).to have_key(:type)
      expect(item[:data][:type]).to be_an(String)
      expect(item[:data][:type]).to eq 'item'

      expect(item[:data]).to have_key(:attributes)

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_an(String)
      expect(item[:data][:attributes][:name]).to eq Item.fifth.name
      

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_an(String)
      expect(item[:data][:attributes][:description]).to eq Item.fifth.description

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_an(Float)
      expect(item[:data][:attributes][:unit_price]).to eq Item.fifth.unit_price

      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:data][:attributes][:merchant_id]).to eq Item.fifth.merchant_id  
    end

    it 'can find an item by maximum price' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      Item.first.update(unit_price: 150)
      Item.second.update(unit_price: 100)
      Item.third.update(unit_price: 75)
      Item.fourth.update(unit_price: 20)
      Item.fifth.update(unit_price: 900)

      maximum_price = 50

      get "/api/v1/items/find?max_price=#{maximum_price}"

      expect(response).to be_successful
      expect(response.status).to eq 200

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item).to have_key(:data)

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_an(String)

      expect(item[:data]).to have_key(:type)
      expect(item[:data][:type]).to be_an(String)
      expect(item[:data][:type]).to eq 'item'

      expect(item[:data]).to have_key(:attributes)

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_an(String)
      expect(item[:data][:attributes][:name]).to eq Item.fourth.name
      

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_an(String)
      expect(item[:data][:attributes][:description]).to eq Item.fourth.description

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_an(Float)
      expect(item[:data][:attributes][:unit_price]).to eq Item.fourth.unit_price

      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:data][:attributes][:merchant_id]).to eq Item.fourth.merchant_id  
    end

    it 'can find an item by using minimum and maximum price' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      Item.first.update(unit_price: 150)
      Item.second.update(unit_price: 100)
      Item.third.update(unit_price: 75)
      Item.fourth.update(unit_price: 20)
      Item.fifth.update(unit_price: 900)

      minimum_price = 50
      maximum_price = 90

      get "/api/v1/items/find?min_price=#{minimum_price}&max_price=#{maximum_price}"

      expect(response).to be_successful
      expect(response.status).to eq 200

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item).to have_key(:data)

      expect(item[:data]).to have_key(:id)
      expect(item[:data][:id]).to be_an(String)

      expect(item[:data]).to have_key(:type)
      expect(item[:data][:type]).to be_an(String)
      expect(item[:data][:type]).to eq 'item'

      expect(item[:data]).to have_key(:attributes)

      expect(item[:data][:attributes]).to have_key(:name)
      expect(item[:data][:attributes][:name]).to be_an(String)
      expect(item[:data][:attributes][:name]).to eq Item.third.name
      

      expect(item[:data][:attributes]).to have_key(:description)
      expect(item[:data][:attributes][:description]).to be_an(String)
      expect(item[:data][:attributes][:description]).to eq Item.third.description

      expect(item[:data][:attributes]).to have_key(:unit_price)
      expect(item[:data][:attributes][:unit_price]).to be_an(Float)
      expect(item[:data][:attributes][:unit_price]).to eq Item.third.unit_price

      expect(item[:data][:attributes]).to have_key(:merchant_id)
      expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
      expect(item[:data][:attributes][:merchant_id]).to eq Item.third.merchant_id  
    end

    it 'returns an empty hash of data if no items are found based on minimum price' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      Item.first.update(unit_price: 101)
      Item.second.update(unit_price: 102)
      Item.third.update(unit_price: 103)
      Item.fourth.update(unit_price: 104)
      Item.fifth.update(unit_price: 105)

      minimum_price = 250

      get "/api/v1/items/find?min_price=#{minimum_price}"

      expect(response).to be_successful
      expect(response.status).to eq 200

      non_item = JSON.parse(response.body, symbolize_names: true)

      expect(non_item).to have_key(:error)
      expect(non_item[:error]).to eq 'No items found based on search criteria.'

      expect(non_item).to have_key(:data)
      expect(non_item[:data]).to eq({})
    end

    it 'returns an empty hash of data if no items are found based on maximum price' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      Item.first.update(unit_price: 101)
      Item.second.update(unit_price: 102)
      Item.third.update(unit_price: 103)
      Item.fourth.update(unit_price: 104)
      Item.fifth.update(unit_price: 105)

      maximum_price = 5

      get "/api/v1/items/find?max_price=#{maximum_price}"

      expect(response).to be_successful
      expect(response.status).to eq 200

      non_item = JSON.parse(response.body, symbolize_names: true)

      expect(non_item).to have_key(:error)
      expect(non_item[:error]).to eq 'No items found based on search criteria.'

      expect(non_item).to have_key(:data)
      expect(non_item[:data]).to eq({})
    end

    it 'returns an empty hash of data if no items are found based on minimum and maximum price' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      Item.first.update(unit_price: 101)
      Item.second.update(unit_price: 102)
      Item.third.update(unit_price: 103)
      Item.fourth.update(unit_price: 104)
      Item.fifth.update(unit_price: 105)

      minimum_price = 106
      maximum_price = 250

      get "/api/v1/items/find?min_price=#{minimum_price}&max_price=#{maximum_price}"

      expect(response).to be_successful
      expect(response.status).to eq 200

      non_item = JSON.parse(response.body, symbolize_names: true)

      expect(non_item).to have_key(:error)
      expect(non_item[:error]).to eq 'No items found based on search criteria.'

      expect(non_item).to have_key(:data)
      expect(non_item[:data]).to eq({})
    end

    it 'returns a 400 if no parameter to find is passed in' do
      get "/api/v1/items/find"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end
    
    it 'returns a 400 if the parameter to find is empty for name' do
      search = ''

      get "/api/v1/items/find?name=#{search}"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end

    it 'returns a 400 if the parameter to find is empty for minimum price' do
      search = ''

      get "/api/v1/items/find?min_price=#{search}"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end

    it 'returns a 400 if the parameter to find is empty for maximum price' do
      search = ''

      get "/api/v1/items/find?max_price=#{search}"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end

    it 'returns a 400 if you try to search with a minimum price and a name for one item' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      minimum_price = 9001
      search_name = "this is a test"

      get "/api/v1/items/find?min_price=#{minimum_price}&name=#{search_name}"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end

    it 'returns a 400 if you try to search with a maximum price and a name for one item' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      maximum_price = 9001
      search_name = "this is a test"

      get "/api/v1/items/find?max_price=#{maximum_price}&name=#{search_name}"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end

    it 'returns a 400 if you try to search with a minimum price, maximum price, and a name for one item' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      minimum_price = 9001
      maximum_price = 9002
      search_name = "this is a test"

      get "/api/v1/items/find?min_price=#{minimum_price}&max_price=#{maximum_price}&name=#{search_name}"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end
  end
  
  describe '#find_all' do
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

    it 'returns a 400 if the parameter to find is empty for name' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      search = ''

      get "/api/v1/items/find_all?name=#{search}"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end

    it 'returns a 400 if the parameter to find is empty for min_price' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      search = ''

      get "/api/v1/items/find_all?min_price=#{search}"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end

    it 'returns a 400 if the parameter to find is empty for max_price' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      search = ''

      get "/api/v1/items/find_all?max_price=#{search}"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end

    it 'returns a 400 if you try to search with a minimum price and a name for all item' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      minimum_price = 9001
      search_name = "this is a test"

      get "/api/v1/items/find_all?min_price=#{minimum_price}&name=#{search_name}"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end

    it 'returns a 400 if you try to search with a maximum price and a name for all item' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      maximum_price = 9001
      search_name = "this is a test"

      get "/api/v1/items/find_all?max_price=#{maximum_price}&name=#{search_name}"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end

    it 'returns a 400 if you try to search with a minimum price, maximum price, and a name for all item' do
      merchant_id = create(:merchant).id
      create_list(:item, 5, merchant_id: merchant_id)

      minimum_price = 9001
      maximum_price = 9002
      search_name = "this is a test"

      get "/api/v1/items/find_all?min_price=#{minimum_price}&max_price=#{maximum_price}&name=#{search_name}"

      expect(response).to_not be_successful
      expect(response.status).to eq 400
    end
  end
end

  # it 'can find all items when searching by minimum price' do
  #   merchant_id = create(:merchant).id
  #   create_list(:item, 5, merchant_id: merchant_id)

  #   # 3 items with price over 200
  #   Item.first.update(unit_price: 9001.0)
  #   Item.second.update(unit_price: 199.0)
  #   Item.third.update(unit_price: 350.00)
  #   Item.fourth.update(unit_price: 201)
  #   Item.fifth.update(unit_price: 2)

  #   min_price = 200
  #   expected_ids = [ Item.first.id, Item.third.id, Item.fourth.id ]

  #   get "/api/v1/items/find_all?min_price=#{min_price}"
    
  #   expect(response).to be_successful
  #   expect(response.status).to eq 200

  #   # Add the rest of the stuff
  # end