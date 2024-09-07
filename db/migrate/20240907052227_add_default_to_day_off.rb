class AddDefaultToDayOff < ActiveRecord::Migration[7.0]
  def change
    change_column_default :timestamps, :day_off, from: nil, to: false
  end
end
