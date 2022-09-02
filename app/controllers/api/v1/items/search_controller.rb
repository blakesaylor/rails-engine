class Api::V1::Items::SearchController < ApplicationController
  def index
    if name_and_price?(params) || all_nil?(params) 
      render status: 400
    elsif params[:name]
      if !params[:name].empty?
        render json: ItemSerializer.new(Item.find_all_by_name(params[:name]))
      else
        render status: 400
      end
    elsif params[:min_price] && params[:max_price]
      render json: ItemSerializer.new(Item.find_all_by_price(params[:min_price], params[:max_price]))
    elsif params[:min_price]
      if !params[:min_price].empty?
        render json: ItemSerializer.new(Item.find_all_by_price(params[:min_price]))
      else
        render status: 400
      end
    elsif params[:max_price]
      if !params[:max_price].empty?
        render json: ItemSerializer.new(Item.find_all_by_price(0, params[:max_price]))
      else
        render status: 400
      end
    end
  end

  def show
    if name_and_price?(params) || all_nil?(params)
      render status: 400
    elsif params[:name]
      if !params[:name].empty?
        if !Item.find_one_by_name(params[:name]).nil?
          render json: ItemSerializer.new(Item.find_one_by_name(params[:name]))
        else 
          render json: { data: {} }
        end
      else
        render status: 400
      end
    elsif params[:min_price] && params[:max_price]
      if params[:min_price].to_f < params[:max_price].to_f
        item = Item.find_one_by_price(params[:min_price], params[:max_price])
        if !item.nil?
          render json: ItemSerializer.new(item)
        else
          render json: { error: 'No items found based on search criteria.', data: {}}
        end
      else
        render json: { error: 'Minimum price must be greater than maximum price.'}, status: 400
      end
    elsif params[:min_price]
      if params[:min_price].empty? || params[:min_price].to_f < 0
        render json: { error: 'Minimum price can not be negative' }, status: 400
      else
        item = Item.find_one_by_price(params[:min_price])
        if !item.nil?
          render json: ItemSerializer.new(item)
        else
          render json: { error: 'No items found based on search criteria.', data: {}}
        end
      end
    elsif params[:max_price]
      if params[:max_price].empty? || params[:max_price].to_f < 0
        render json: { error: 'Maximum price can not be negative' }, status: 400
      else
        item = Item.find_one_by_price(0, params[:max_price])
        if !item.nil?
          render json: ItemSerializer.new(item)
        else
          render json: { error: 'No items found based on search criteria.', data: {}}
        end
      end
    end
  end

  private
    def name_and_price?(params)
      params[:name] && (params[:min_price] || params[:max_price])
    end
    
    def all_nil?(params)
      params[:name].nil? && params[:min_price].nil? && params[:max_price].nil?
    end
end