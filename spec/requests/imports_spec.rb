require 'rails_helper'

RSpec.describe "Imports", type: :request do
  describe "GET /imports/new" do
    it "returns a successful response" do
      get new_import_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /imports" do
    let(:valid_file) do
      csv_content = <<~CSV
        "Customer","Supplier","Quote","Tax Included","State","Tax Rate"
        "Acme Corp","PowerCo",0.0662,"Y","MA",7.5
      CSV
      Rack::Test::UploadedFile.new(
        StringIO.new(csv_content),
        "text/csv",
        original_filename: "quotes.csv"
      )
    end

    it "imports the CSV and redirects to quotes" do
      post imports_path, params: { file: valid_file }
      expect(response).to redirect_to(quotes_path)
    end
  end
end
