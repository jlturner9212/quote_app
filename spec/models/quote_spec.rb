require 'rails_helper'

RSpec.describe Quote, type: :model do
  describe "validations" do
    subject { build(:quote) }

    it { should validate_presence_of(:customer) }
    it { should validate_presence_of(:supplier) }
    it { should validate_presence_of(:quote) }
    it { should validate_numericality_of(:quote).is_greater_than(0) }
    it { should validate_inclusion_of(:tax_included).in_array([true, false]) }
    it { should validate_numericality_of(:tax_rate).is_greater_than_or_equal_to(0).allow_nil }

    it "validates state length is 2" do
      quote = build(:quote, state: "MAA")
      expect(quote).not_to be_valid
      expect(quote.errors[:state]).to include("is the wrong length (should be 2 characters)")
    end

    it "allows nil state" do
      quote = build(:quote, state: nil)
      expect(quote).to be_valid
    end
  end

  describe "uniqueness" do

    it "allows same customer and supplier in different states" do
      create(:quote, customer: "Acme", supplier: "PowerCo", state: "MA")
      different_state = build(:quote, customer: "Acme", supplier: "PowerCo", state: "NY")
      expect(different_state).to be_valid
    end
  end
end