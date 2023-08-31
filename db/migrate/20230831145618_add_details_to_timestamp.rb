class AddDetailsToTimestamp < ActiveRecord::Migration[7.0]
  def change
    add_column :timestamps, :user_id, :integer
    add_column :timestamps, :year, :integer
    add_column :timestamps, :month, :integer
    add_column :timestamps, :date, :integer
    add_column :timestamps, :start_time_h, :string
    add_column :timestamps, :start_time_m, :string
    add_column :timestamps, :finish_time_h, :string
    add_column :timestamps, :finish_time_m, :string
    add_column :timestamps, :name, :string
    add_column :timestamps, :place, :string
    add_column :timestamps, :desc, :string
  end
end
