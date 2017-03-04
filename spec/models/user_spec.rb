require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'is invalid with missing attributes' do
    user_attrs = attributes_for(:user).except(:username)
    user = User.new user_attrs
    expect(user).to be_invalid
  end

  it 'is invalid with non-unique email or username' do
    create(:user)
    user = build(:user)
    expect(user.save).to be false
  end
end
