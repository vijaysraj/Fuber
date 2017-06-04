require 'rails_helper'

RSpec.describe Ride, type: :model do
    context "Associations" do

    it "should belong to cab" do
      t = Ride.reflect_on_association(:cab)
      expect(t.macro).to eq(:belongs_to)
    end
  end
end
