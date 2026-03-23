class CreateQuotes < ActiveRecord::Migration[7.2]
  def change
    create_table :quotes do |t|
      t.string :customer
      t.string :supplier
      t.decimal :quote
      t.boolean :tax_included
      t.string :state
      t.decimal :tax_rate

      t.timestamps
    end
  end
end
