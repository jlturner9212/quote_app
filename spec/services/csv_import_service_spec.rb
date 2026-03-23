require 'rails_helper'

RSpec.describe CsvImportService do
  let(:valid_csv) do
    csv_content = <<~CSV
      "Customer","Supplier","Quote","Tax Included","State","Tax Rate"
      "Acme Corp","PowerCo",0.0662,"Y","MA",7.5
      "Acme Corp","GreenEnergy",0.0723,"N","NY",8.0
      "Beta LLC","PowerCo",0.0688,"Y","CA",6.5
    CSV
    instance_double("file", read: csv_content)
  end

  let(:invalid_csv) do
    csv_content = <<~CSV
      "Customer","Supplier","Quote","Tax Included","State","Tax Rate"
      "","PowerCo",0.0662,"Y","MA",7.5
    CSV
    instance_double("file", read: csv_content)
  end

  it "updates an existing quote when the rate changes" do
    create(:quote, customer: "Acme Corp", supplier: "PowerCo", state: "MA", quote: 0.0662, tax_rate: 7.5)

    updated_csv = instance_double("file", read: <<~CSV)
      "Customer","Supplier","Quote","Tax Included","State","Tax Rate"
      "Acme Corp","PowerCo",0.0724,"Y","MA",8.0
    CSV

    result = CsvImportService.new(updated_csv).call

    expect(result.updated_count).to eq(1)
    expect(result.imported_count).to eq(0)

    updated = Quote.find_by(customer: "Acme Corp", supplier: "PowerCo", state: "MA")
    expect(updated.quote).to eq(0.0724)
    expect(updated.tax_rate).to eq(8.0)
  end

  describe "#call" do
    it "imports all valid rows" do
      result = CsvImportService.new(valid_csv).call
      expect(result.imported_count).to eq(3)
      expect(result.skipped_count).to eq(0)
      expect(result.errors).to be_empty
    end

    it "creates Quote records in the database" do
      expect {
        CsvImportService.new(valid_csv).call
      }.to change(Quote, :count).by(3)
    end

    it "returns success? true when no errors" do
      result = CsvImportService.new(valid_csv).call
      expect(result.success?).to be true
    end

    it "records errors for invalid rows" do
      result = CsvImportService.new(invalid_csv).call
      expect(result.errors).not_to be_empty
      expect(result.success?).to be false
    end

    it "correctly maps tax_included Y to true" do
      CsvImportService.new(valid_csv).call
      quote = Quote.find_by(customer: "Acme Corp", supplier: "PowerCo", state: "MA")
      expect(quote.tax_included).to be true
    end

    it "correctly maps tax_included N to false" do
      CsvImportService.new(valid_csv).call
      quote = Quote.find_by(customer: "Acme Corp", supplier: "GreenEnergy", state: "NY")
      expect(quote.tax_included).to be false
    end
  end
end