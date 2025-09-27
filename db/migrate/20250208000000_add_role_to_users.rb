class AddRoleToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :role, :string, null: false, default: "employee"

    execute <<~SQL.squish
      UPDATE users SET role = 'employee' WHERE role IS NULL
    SQL

    add_index :users, :role
  end

  def down
    remove_index :users, :role
    remove_column :users, :role
  end
end
