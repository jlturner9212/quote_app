require 'rails_helper'

RSpec.describe "Quotes", type: :request do
  describe "GET /quotes" do
    it "returns a successful response" do
      get quotes_path
      expect(response).to have_http_status(:ok)
    end

    it "displays imported quotes" do
      create(:quote, customer: "Acme Corp", supplier: "PowerCo", state: "MA")
      get quotes_path
      expect(response.body).to include("Acme Corp")
      expect(response.body).to include("PowerCo")
    end
  end

  describe "GET /quotes/:id" do
    let(:quote) { create(:quote) }

    it "returns a successful response" do
      get quote_path(quote)
      expect(response).to have_http_status(:ok)
    end

    it "displays the quote details" do
      get quote_path(quote)
      expect(response.body).to include(quote.customer)
      expect(response.body).to include(quote.supplier)
    end
  end
end