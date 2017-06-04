require 'rails_helper'

RSpec.describe Cab, type: :model do
  context "Associations" do

    it "should have many rides" do
      t = Cab.reflect_on_association(:rides)
      expect(t.macro).to eq(:has_many)
    end
  end
end
