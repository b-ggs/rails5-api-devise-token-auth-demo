require 'rails_helper'

RSpec.configure do |config|
  config.include ItemsHelper
end

RSpec.describe ItemsController, type: :controller do
  let! (:user) { create(:user) }
 
  before do
    authenticate_user user
    @item_params = {
      name: "Foobar",
      description: "I am a foobar!"
      quantity: 1
    }
  end

  describe 'GET /items' do
    items = []
    8.times items << Item.create @item_params
    byebug
  end
end
