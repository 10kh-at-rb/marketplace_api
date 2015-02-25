require 'rails_helper'

RSpec.describe Order do
  subject { Fabricate.build(:order) }

  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:total)}
  it { is_expected.to validate_numericality_of(:total).is_greater_than_or_equal_to(0) }
  it { is_expected.to belong_to(:user) }
end
