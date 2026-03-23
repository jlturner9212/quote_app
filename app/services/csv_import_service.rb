require "csv"

class CsvImportService
  attr_reader :imported_count, :skipped_count, :updated_count, :errors

  def initialize(file)
    @file = file
    @imported_count = 0
    @skipped_count = 0
    @updated_count = 0
    @errors = []
  end

  def call
    rows = CSV.parse(@file.read, headers: true)

    rows.each_with_index do |row, i|      # Use Find or init instead of looking for dups / faster option for large write would be upsert_all
      record = Quote.find_or_initialize_by(
        customer: row["Customer"]&.strip,
        supplier: row["Supplier"]&.strip,
        state:    row["State"]&.strip
      )

      record.assign_attributes(
        quote:        row["Quote"].to_d,
        tax_included: row["Tax Included"]&.strip == "Y",
        tax_rate:     row["Tax Rate"].to_d
      )

      if record.save
        record.previously_new_record? ? @imported_count += 1 : @updated_count += 1
      else
        @errors << "Row #{i + 2}: #{record.errors.full_messages.join(', ')}"
      end
    end

    self
  end

  def success?
    @errors.empty?
  end
end
