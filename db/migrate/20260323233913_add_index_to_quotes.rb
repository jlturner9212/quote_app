class AddIndexToQuotes < ActiveRecord::Migration[7.2]
  def change
    add_index :quotes, [:customer, :supplier, :state], unique: true
  end
end
