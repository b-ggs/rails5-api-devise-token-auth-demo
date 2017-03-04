require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @username = 'foobar'
    @email = 'foo@bar.com'
    @password = 'quxbarfoo'
  end

  it 'is valid with valid attributes' do
    user = User.new(
      username: @username,
      email: @email,
      password: @password
    )
    expect(user).to be_valid
  end

  it 'is invalid with missing attributes' do
    user = User.new(
      username: @username,
      password: @password
    )
    expect(user).to be_invalid
  end

  it 'is invalid with non-unique email or username' do
    user = User.new(
      username: @username,
      email: @email,
      password: @password
    )
    user.save
    expect(user.dup.save).to be false
  end
end
