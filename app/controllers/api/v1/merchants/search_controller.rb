class Api::V1::Merchants::SearchController < ApplicationController
  def index
    
  end

  def show
    if !params[:name].nil? && !params[:name].empty?
      if !Merchant.find_one(params[:name]).nil?
        render json: MerchantSerializer.new(Merchant.find_one(params[:name]))
      else 
        render json: { data: {} }
      end
    else
      render status: 400
    end
  end
end