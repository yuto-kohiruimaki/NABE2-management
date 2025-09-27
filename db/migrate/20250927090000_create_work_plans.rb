class CreateWorkPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :work_plans do |t|
      t.references :user, null: false, foreign_key: true
      t.date :period, null: false
      t.integer :planned_working_days, null: false, default: 0
      t.integer :planned_working_hours
      t.text :notes
      t.references :created_by, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :work_plans, [:user_id, :period], unique: true
  end
end
