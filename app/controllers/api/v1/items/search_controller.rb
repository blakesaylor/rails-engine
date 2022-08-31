class Api::V1::Items::SearchController < ApplicationController
  def index
    if !params[:name].nil? && !params[:name].empty?
      render json: ItemSerializer.new(Item.find_all(params[:name]))
    else
      render status: 400
    end
  end

  def show

  end
end