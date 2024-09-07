class AddDayOffToTimestamps < ActiveRecord::Migration[7.0]
  def change
    add_column :timestamps, :day_off, :boolean
  end
end
