class CreateTransaction < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :payer
      t.integer :points
      t.timestamps
    end
  end
end
