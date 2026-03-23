class QuotesController < ApplicationController
  before_action :set_quote, only: %i[ show ]

  def index
    @quotes = Quote
      .search(params[:q])
      .by_state(params[:state])
      .order(:customer, :supplier)
  end

  def show
  end

  private
    def set_quote
      @quote = Quote.find(params[:id])
    end
end
