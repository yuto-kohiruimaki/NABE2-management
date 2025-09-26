class TimesController < ApplicationController
    before_action :authenticate_user!
    before_action :get_abs_date, only: [:create, :update, :destroy]
  
    def index
      @timestamps = Timestamp.all.order(updated_at: "DESC")
    end
  
    def new
        @userName = current_user.name
        @place = params[:place]
    end
  
    def create
      # 日付を作成
      work_date = Date.new(@abs_this_year, params[:month].to_i, params[:date].to_i)
      
      # 時間を作成（値がある場合のみ）
      start_time = nil
      finish_time = nil
      
      if params[:start_time_h].present? && params[:start_time_m].present?
        start_time = work_date.to_datetime + params[:start_time_h].to_i.hours + params[:start_time_m].to_i.minutes
      end
      
      if params[:finish_time_h].present? && params[:finish_time_m].present?
        finish_time = work_date.to_datetime + params[:finish_time_h].to_i.hours + params[:finish_time_m].to_i.minutes
        # 終了時間が開始時間より前の場合、翌日として処理
        if finish_time && start_time && finish_time < start_time
          finish_time += 1.day
        end
      end
      
      timestamp = Timestamp.new(
        name: params[:name],
        place: params[:place],
        work_date: work_date,
        start_time: start_time,
        finish_time: finish_time,
        day_off: params[:day_off],
        desc: params[:desc],
        user_id: current_user.id
      )
      timestamp.save
      redirect_to user_path(id: current_user.id, year: @abs_this_year, month: @abs_this_month)
    end
  
    def edit
      @timestamp = Timestamp.find_by(id: params[:id])
    end
  
    def update
      @timestamp = Timestamp.find_by(id: params[:id])
      
      # 日付を作成
      work_date = Date.new(@abs_this_year, params[:month].to_i, params[:date].to_i)
      
      # 時間を作成（値がある場合のみ）
      start_time = nil
      finish_time = nil
      
      if params[:start_time_h].present? && params[:start_time_m].present?
        start_time = work_date.to_datetime + params[:start_time_h].to_i.hours + params[:start_time_m].to_i.minutes
      end
      
      if params[:finish_time_h].present? && params[:finish_time_m].present?
        finish_time = work_date.to_datetime + params[:finish_time_h].to_i.hours + params[:finish_time_m].to_i.minutes
        # 終了時間が開始時間より前の場合、翌日として処理
        if finish_time && start_time && finish_time < start_time
          finish_time += 1.day
        end
      end
      
      @timestamp.name = params[:name]
      @timestamp.place = params[:place]
      @timestamp.work_date = work_date
      @timestamp.start_time = start_time
      @timestamp.finish_time = finish_time
      @timestamp.day_off = params[:day_off]
      @timestamp.desc = params[:desc]
      @timestamp.save
      redirect_to user_path(id: current_user.id, year: @abs_this_year, month: @abs_this_month)
    end
  
    def destroy
      timestamp_post = Timestamp.find_by(id: params[:id])
      timestamp_post.destroy
      redirect_to user_path(id: current_user.id, year: @abs_this_year, month: @abs_this_month)
    end

    def show
        @timestamp = Timestamp.find(params[:id])
        @userName = @timestamp.name
        @place = @timestamp.place
        @month = @timestamp.work_date&.month
        @date = @timestamp.work_date&.day
        # 時刻を2桁表示にフォーマット
        @start_time_h = @timestamp.start_time ? sprintf("%02d", @timestamp.start_time.hour) : nil
        @start_time_m = @timestamp.start_time ? sprintf("%02d", @timestamp.start_time.min) : nil
        @finish_time_h = @timestamp.finish_time ? sprintf("%02d", @timestamp.finish_time.hour) : nil
        @finish_time_m = @timestamp.finish_time ? sprintf("%02d", @timestamp.finish_time.min) : nil
        @day_off = @timestamp.day_off
        @desc = @timestamp.desc
        @userId = @timestamp.user_id
    end

    private

    def get_abs_date
      now = Date.today
      @abs_this_year = now.year
      @abs_this_month = now.month
    end
end
  