class Quote < ApplicationRecord
  validates :customer,     presence: true
  validates :supplier,     presence: true
  validates :quote,        presence: true, numericality: { greater_than: 0 }
  validates :tax_included, inclusion: { in: [true, false] }
  validates :state,        length: { is: 2 }, allow_nil: true
  validates :tax_rate,     numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :supplier,     uniqueness: { scope: [:customer, :state], message: "already have a quote for this customer in this state" }

end
