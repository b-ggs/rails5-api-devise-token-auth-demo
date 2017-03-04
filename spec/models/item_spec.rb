require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'is valid with valid attributes' do
    item = build(:item)
    expect(item).to be_valid
  end

  it 'is invalid with missing attributes' do
    item_attrs = attributes_for(:item).except(:name)
    item = Item.new item_attrs
    expect(item).to be_invalid
  end

  it 'is invalid with non-unique name' do
    item_attrs = attributes_for(:item)
    Item.create item_attrs
    item = Item.new item_attrs
    expect(item.save).to be false
  end
end
