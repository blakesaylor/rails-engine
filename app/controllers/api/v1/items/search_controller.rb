class Api::V1::Items::SearchController < ApplicationController
  def index
    if !params[:name].nil? && !params[:name].empty?
      render json: ItemSerializer.new(Item.find_all(params[:name]))
    else
      render status: 400
    end
  end

  def show
    if !params[:name].nil? && !params[:name].empty?
      if !Item.find_one(params[:name]).nil?
        render json: ItemSerializer.new(Item.find_one(params[:name]))
      else 
        render json: { data: {} }
      end
    else
      render status: 400
    end
  end
end