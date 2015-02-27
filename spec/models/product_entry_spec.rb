require 'rails_helper'

RSpec.describe ProductEntry do
  it { is_expected.to belong_to(:order).inverse_of(:product_entries) }
  it { is_expected.to belong_to(:product).inverse_of(:product_entries) }
end
