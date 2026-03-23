class ImportsController < ApplicationController
  def new
  end

  def create
    file = params[:file]

    if file.nil?
      flash[:alert] = "Please select a CSV file to upload."
      return redirect_to new_import_path
    end

    unless file.content_type.in?(%w[text/csv])
      flash[:alert] = "Invalid file type. Please upload a CSV file."
      return redirect_to new_import_path
    end

    result = CsvImportService.new(file).call

    if result.success?
      flash[:notice] = "Import complete — #{result.imported_count} imported, #{result.skipped_count} skipped."
    else
      flash[:alert] = "Import completed with errors: #{result.errors.join(' | ')}"
    end

    redirect_to quotes_path
  end
end
