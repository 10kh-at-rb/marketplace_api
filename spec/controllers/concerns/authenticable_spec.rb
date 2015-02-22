require 'rails_helper'

class Authentication
  include Authenticable
  def request; end
end

RSpec.describe Authenticable do
  let(:authentication) { Authentication.new }

  describe "#current_user" do
    it "returns the user from the authorization header" do
      user = Fabricate(:user)
      request.headers["Authorization"] = user.auth_token
      allow(authentication).to receive(:request) { request }
      expect(authentication.current_user).to eq(user)
    end
  end
end
