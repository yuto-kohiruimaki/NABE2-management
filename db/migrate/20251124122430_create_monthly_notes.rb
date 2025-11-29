class CreateMonthlyNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :monthly_notes do |t|
      t.string :month, null: false
      t.text :description

      t.timestamps
    end
    add_index :monthly_notes, :month, unique: true
  end
end
