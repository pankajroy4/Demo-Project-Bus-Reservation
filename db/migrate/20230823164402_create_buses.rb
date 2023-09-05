

class CreateBuses < ActiveRecord::Migration[7.0]
  def change
    create_table :buses do |t|
      t.string :name
      t.string :registration_no
      t.string :route
      t.integer :total_seat
      t.boolean :approved, default: false
      t.references :bus_owner, null: false, foreign_key: { to_table: :users }
      # t.references :admin, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
