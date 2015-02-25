require 'api_constraints'
require 'rails_helper'

RSpec.describe ApiConstraints do
  describe "matches?" do
    it "returns true when the version matches the 'Accept' header" do
      api_constraints = ApiConstraints.new(version: 1)
      req = double(host: "api.marketplace.dev",
                   headers: {"Accept" => "application/vnd.marketplace.v1"})
      expect(api_constraints.matches?(req)).to be true
    end

    it "returns the default version when 'default' option is specified" do
      api_constraints = ApiConstraints.new(version: 2, default: true)
      req = double(host: "api.marketplace.dev")
      expect(api_constraints.matches?(req)).to be true
    end
  end
end
