require "rails_helper"

# Resource: https://github.com/lynndylanhurley/devise_token_auth/issues/75#issuecomment-258496229

RSpec.describe "Auth", :type => :request do
  before do
    username = 'foobar'
    email = 'foo@bar.com'
    password = 'quxbarfoo'
    @sign_in_params = {
      email: email,
      password: password
    }
    @registration_params = {
      username: username,
      email: email,
      password: password
    }
  end

  describe 'POST /auth' do
    it 'should respond with 200 OK' do
      post user_registration_path @registration_params
      expect(response).to be_success 
    end

    it 'should increase user count by 1' do
      expect{
        post user_registration_path @registration_params
      }.to change(User, :count).by(1)
    end
  end

  describe 'GET /auth/confirmation' do
    before do
      post user_registration_path @registration_params
      @user = User.last
    end

    it 'should respond with 301 REDIRECTION' do
      get user_confirmation_path(:config => 'default', :confirmation_token => @user.confirmation_token, :redirect_url => '/')
      expect(response).to be_redirect
    end
  end

  describe 'POST /auth/sign_in' do
    before do
      post user_registration_path @registration_params
      user = User.last
      get user_confirmation_path(:config => 'default', :confirmation_token => user.confirmation_token, :redirect_url => '/')
    end

    it 'should respond with 200 OK' do
      post user_session_path @sign_in_params
      expect(response).to be_success 
    end
  end
end
