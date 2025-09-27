class AddIsDeletedToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :is_deleted, :boolean, null: false, default: false
    add_index :users, :is_deleted
  end
end
