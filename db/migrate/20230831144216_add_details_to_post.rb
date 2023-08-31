class AddDetailsToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :user_id, :integer
    add_column :posts, :year, :integer
    add_column :posts, :month, :integer
    add_column :posts, :date, :integer
    add_column :posts, :place, :string
    add_column :posts, :name, :string
    add_column :posts, :desc, :text
  end
end
