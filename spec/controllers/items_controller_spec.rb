require 'rails_helper'

RSpec.configure do |config|
  config.include ItemsHelper
end

RSpec.describe ItemsController, type: :controller do
  let! (:user) { create(:user) }
 
  before do
    authenticate_user user
    @items = []
    8.times { @items << create(:item) }
  end

  describe 'GET /items' do
    before do
      @expected_response = {
        items: JSON.parse(@items.to_json)
      }
    end

    it 'displays all saved items' do
      get :index
      expect(response.body).to eq(@expected_response.to_json)
    end
  end

  describe 'GET /items/1' do
    it 'displays the item with ID 1' do
      @expected_response = {
        item: JSON.parse(@items.first.to_json)
      }
      get :show, params: { id: @items.first.id }, flash: nil
      expect(response.body).to eq(@expected_response.to_json)
    end

    it 'displays a helpful message when item is not found' do
      get :show, params: { id: 999 }, flash: nil
      expect(response.body).to include("Can't find")
    end
  end

  describe 'PUT /items/:id' do
    it 'updates an existing item successfully' do
      put :update, params: { id: Item.first.id, name: "Qux" }
      expect(Item.first.name).to eq("Qux")
    end

    it 'displays a helpful message when item is not found' do
      get :show, params: { id: 999 }, flash: nil
      expect(response.body).to include("Can't find")
    end
  end

  describe 'POST /items' do 
    before do
      @item_params = attributes_for(:item)
    end

    it 'creates an item with valid attributes' do
      post :create, params: @item_params
      expect(response).to be_success
    end

    it 'doesn\'t create an item with invalid attributes' do
      post :create, params: @item_params.except(:name)
      expect(response).to_not be_success
    end
  end

  describe 'DELETE /items/:id' do
    it 'deletes an existing item successfully' do
      expect{
        delete :destroy, params: { id: Item.first.id }
      }.to change(Item, :count).by(-1)
    end

    it 'displays a helpful message when item is not found' do
      get :show, params: { id: 999 }, flash: nil
      expect(response.body).to include("Can't find")
    end
  end
end
