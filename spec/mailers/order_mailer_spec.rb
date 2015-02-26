require 'rails_helper'

RSpec.describe OrderMailer do
  include Rails.application.routes.url_helpers
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  describe ".send_confirmation" do
    let(:order) { Fabricate(:order) }
    let(:user) { order.user }
    subject { OrderMailer.send_confirmation(order) }

    it { is_expected.to deliver_to(user.email) }
    it { is_expected.to deliver_from("hogwarts@wizardry.org") }
    it { is_expected.to have_body_text(/Order: ##{order.id}/) }
    it { is_expected.to have_subject(/Order Confirmation/) }
    it { is_expected.to have_body_text(/ordered #{order.products.count} products/) }
  end
end
