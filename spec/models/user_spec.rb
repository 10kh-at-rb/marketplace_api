require 'rails_helper' 

RSpec.describe User do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_confirmation_of(:password) }
  it { should allow_value("user@example.io").for(:email) }
end
