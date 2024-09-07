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
      timestamp = Timestamp.new(name:params[:name], place:params[:place], year: @abs_this_year, month:params[:month], date:params[:date], start_time_h:params[:start_time_h], start_time_m:params[:start_time_m], finish_time_h:params[:finish_time_h], finish_time_m:params[:finish_time_m], day_off:params[:day_off], desc:params[:desc], user_id:current_user.id,)
      timestamp.save
      redirect_to user_path(id: current_user.id, year: @abs_this_year, month: @abs_this_month)
    end
  
    def edit
      @timestamp = Timestamp.find_by(id: params[:id])
    end
  
    def update
      @timestamp = Timestamp.find_by(id: params[:id])
      @timestamp.name = params[:name]
      @timestamp.place = params[:place]
      @timestamp.month = params[:month]
      @timestamp.date = params[:date]
      @timestamp.start_time_h = params[:start_time_h]
      @timestamp.start_time_m = params[:start_time_m]
      @timestamp.finish_time_h = params[:finish_time_h]
      @timestamp.finish_time_m = params[:finish_time_m]
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
        @month = @timestamp.month
        @date = @timestamp.date
        @start_time_h = @timestamp.start_time_h
        @start_time_m = @timestamp.start_time_m
        @finish_time_h = @timestamp.finish_time_h
        @finish_time_m = @timestamp.finish_time_m
        @desc = @timestamp.desc
        @userId = @timestamp.user_id

        if ActiveRecord::Base.connection.column_exists?(:timestamps, :day_off)
          @is_day_off = @timestamp.day_off
        else
          @is_day_off = false
        end
    end

    private

    def get_abs_date
      now = Date.today
      @abs_this_year = now.year
      @abs_this_month = now.month
    end
end
  