require 'rails_helper' 

RSpec.describe User do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to allow_value("user@example.io").for(:email) }

  describe "#generate_auth_token!" do
    it "generates a unique token" do
      existing_user = Fabricate(:user, auth_token: "existing_token")
      user = Fabricate(:user)
      user.generate_auth_token!
      expect(user.auth_token).not_to eq(existing_user.auth_token)
    end

    it "is called by a before_create callback" do
      expect(Fabricate(:user).auth_token).not_to be_nil
    end
  end
end
