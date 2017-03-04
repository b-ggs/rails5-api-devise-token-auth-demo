class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :fetch_item, except: [:index, :create]
  
  def index
    render json: {
      items: Item.all
    }, status: :ok
  end

  def show
    render json: {
      item: @item
    }, status: :ok
  end

  def create
    @item = Item.new item_params
    if @item.save
      message = "Successfully created new item."
      render json: {
        message: message,
        item: @item
      }, status: :ok
    else
      message = "There was a problem creating this item."
      render json: {
        message: message,
        item: @item,
        errors: @item.errors
      }, status: :unprocessable_entity
    end
  end

  def update
    if @item.update_attributes item_params
      message = "Successfully updated item."
      render json: {
        message: message,
        item: @item,
      }, status: :ok
    else
      message = "There was a problem updating item."
      render json: {
        message: message,
        item: @item,
        errors: @item.errors,
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @item.destroy
      message = "Successfully removed item."
      render json: {
        message: message,
      }, status: :ok
    else 
      message = "There was a problem removing this item."
      render json: { 
        message: message,
        item: @item,
        errors: @item.errors,
      }, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.permit(:name, :description, :quantity)
  end

  def fetch_item
    @item = Item.find_by id: params[:id]
    unless @item
      message = "Can't find Item with id #{params[:id]}."
      render json: {
        message: message,
        params: params
      }, status: :not_found
    end
  end
end
