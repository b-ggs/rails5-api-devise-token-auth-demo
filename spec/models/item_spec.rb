require 'rails_helper'

RSpec.describe Item, type: :model do
  before do
    @name = 'foobar'
    @description = 'I am a foobar.'
    @quantity = 1
  end

  it 'is valid with valid attributes' do
    item = Item.new(
      name: @name,
      description: @description,
      quantity: @quantity,
    )
    expect(item).to be_valid
  end

  it 'is invalid with missing attributes' do
    item = Item.new(
      name: @name,
      quantity: @quantity,
    )
    expect(item).to be_invalid
  end

  it 'is invalid with non-unique name' do
    item = Item.new(
      name: @name,
      quantity: @quantity,
    )
    item.save
    expect(item.dup.save).to be false
  end
end
