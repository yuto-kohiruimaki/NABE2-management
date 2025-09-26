class ConvertTimeFieldsToTimestamp < ActiveRecord::Migration[7.0]
  def up
    # timestampsテーブルの変更
    # 一時的なカラムを追加
    add_column :timestamps, :start_time, :datetime
    add_column :timestamps, :finish_time, :datetime
    add_column :timestamps, :work_date, :date
    
    # 既存のデータを新しいカラムに移行
    Timestamp.reset_column_information
    Timestamp.find_each do |timestamp|
      if timestamp.year.present? && timestamp.month.present? && timestamp.date.present?
        work_date = Date.new(timestamp.year, timestamp.month, timestamp.date) rescue nil
        
        if work_date
          # 開始時間の設定
          if timestamp.start_time_h.present? && timestamp.start_time_m.present?
            start_hour = timestamp.start_time_h.to_i
            start_minute = timestamp.start_time_m.to_i
            timestamp.start_time = work_date.to_datetime + start_hour.hours + start_minute.minutes
          end
          
          # 終了時間の設定
          if timestamp.finish_time_h.present? && timestamp.finish_time_m.present?
            finish_hour = timestamp.finish_time_h.to_i
            finish_minute = timestamp.finish_time_m.to_i
            timestamp.finish_time = work_date.to_datetime + finish_hour.hours + finish_minute.minutes
            
            # 終了時間が開始時間より前の場合、翌日として処理
            if timestamp.finish_time && timestamp.start_time && timestamp.finish_time < timestamp.start_time
              timestamp.finish_time += 1.day
            end
          end
          
          timestamp.work_date = work_date
          timestamp.save!(validate: false)
        end
      end
    end
    
    # 古いカラムを削除
    remove_column :timestamps, :year
    remove_column :timestamps, :month
    remove_column :timestamps, :date
    remove_column :timestamps, :start_time_h
    remove_column :timestamps, :start_time_m
    remove_column :timestamps, :finish_time_h
    remove_column :timestamps, :finish_time_m
    
    # postsテーブルの変更
    add_column :posts, :post_date, :date
    
    # 既存のデータを新しいカラムに移行
    Post.reset_column_information
    Post.find_each do |post|
      if post.year.present? && post.month.present? && post.date.present?
        post_date = Date.new(post.year, post.month, post.date) rescue nil
        if post_date
          post.post_date = post_date
          post.save!(validate: false)
        end
      end
    end
    
    # 古いカラムを削除
    remove_column :posts, :year
    remove_column :posts, :month
    remove_column :posts, :date
    
    # インデックスを追加
    add_index :timestamps, :user_id
    add_index :timestamps, :work_date
    add_index :timestamps, [:user_id, :work_date]
    add_index :posts, :user_id
    add_index :posts, :post_date
    add_index :posts, [:user_id, :post_date]
  end
  
  def down
    # timestampsテーブルのロールバック
    add_column :timestamps, :year, :integer
    add_column :timestamps, :month, :integer
    add_column :timestamps, :date, :integer
    add_column :timestamps, :start_time_h, :string
    add_column :timestamps, :start_time_m, :string
    add_column :timestamps, :finish_time_h, :string
    add_column :timestamps, :finish_time_m, :string
    
    Timestamp.reset_column_information
    Timestamp.find_each do |timestamp|
      if timestamp.work_date.present?
        timestamp.year = timestamp.work_date.year
        timestamp.month = timestamp.work_date.month
        timestamp.date = timestamp.work_date.day
        
        if timestamp.start_time.present?
          timestamp.start_time_h = timestamp.start_time.hour.to_s
          timestamp.start_time_m = timestamp.start_time.min.to_s
        end
        
        if timestamp.finish_time.present?
          timestamp.finish_time_h = timestamp.finish_time.hour.to_s
          timestamp.finish_time_m = timestamp.finish_time.min.to_s
        end
        
        timestamp.save!(validate: false)
      end
    end
    
    remove_column :timestamps, :start_time
    remove_column :timestamps, :finish_time
    remove_column :timestamps, :work_date
    
    # postsテーブルのロールバック
    add_column :posts, :year, :integer
    add_column :posts, :month, :integer
    add_column :posts, :date, :integer
    
    Post.reset_column_information
    Post.find_each do |post|
      if post.post_date.present?
        post.year = post.post_date.year
        post.month = post.post_date.month
        post.date = post.post_date.day
        post.save!(validate: false)
      end
    end
    
    remove_column :posts, :post_date
    
    # インデックスを削除
    remove_index :timestamps, :user_id
    remove_index :timestamps, :work_date
    remove_index :timestamps, [:user_id, :work_date]
    remove_index :posts, :user_id
    remove_index :posts, :post_date
    remove_index :posts, [:user_id, :post_date]
  end
end
