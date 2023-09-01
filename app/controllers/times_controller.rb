class TimesController < ApplicationController
    before_action :authenticate_user!
  
    def index
      @timestamps = Timestamp.all.order(updated_at: "DESC")
    end
  
    def new
      @userName = current_user.name
    end
  
    def create
      now = Date.today
      this_year = now.year
  
      timestamp = Timestamp.new(name:params[:name], year: this_year, month:params[:month], date:params[:date], start_time_h:params[:start_time_h], start_time_m:params[:start_time_m], finish_time_h:params[:finish_time_h], finish_time_m:params[:finish_time_m], desc:params[:desc], user_id:current_user.id,)
      timestamp.save
      redirect_to user_path(id: current_user.id)
    end
  
    def edit
      @timestamp = Timestamp.find_by(id: params[:id])
    end
  
    def update
      @timestamp = Timestamp.find_by(id: params[:id])
      @timestamp.name = params[:name]
      @timestamp.month = params[:month]
      @timestamp.date = params[:date]
      @timestamp.start_time_h = params[:start_time_h]
      @timestamp.start_time_m = params[:start_time_m]
      @timestamp.finish_time_h = params[:finish_time_h]
      @timestamp.finish_time_m = params[:finish_time_m]
      @timestamp.desc = params[:desc]
      @timestamp.save
      redirect_to user_path(id: current_user.id)
    end
  
    def destroy
      timestamp_post = Timestamp.find_by(id: params[:id])
      timestamp_post.destroy
      redirect_to user_path(id: current_user.id)
    end

    def show
        @timestamp = Timestamp.find(params[:id])
        @userName = @timestamp.name
        @month = @timestamp.month
        @date = @timestamp.date
        @start_time_h = @timestamp.start_time_h
        @start_time_m = @timestamp.start_time_m
        @finish_time_h = @timestamp.finish_time_h
        @finish_time_m = @timestamp.finish_time_m
        @desc = @timestamp.desc
        @userId = @timestamp.user_id
    end
  
end
  