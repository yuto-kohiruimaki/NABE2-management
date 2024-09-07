class UsersController < ApplicationController
    before_action :authenticate_user!
  
    def show
      @user = User.find(params[:id])
      @posts = Post.where(user_id: @user.id)
      @timestamps = Timestamp.where(user_id: params[:id])

      @x = 0

      if params[:p].present?
        @x = params[:p].to_i - 1
      elsif params[:n].present?
        @x = params[:n].to_i + 1
      else
        @x = 0
      end

      @this_year = params[:year].to_i
      @this_month = params[:month].to_i + @x

      @wday = ["日", "月", "火", "水", "木", "金", "土"]

      if @this_month > 12
        @this_month -= 12
        @this_year += 1
      elsif @this_month < 1
        @this_month += 12
        @this_year -= 1
      end

      def adjust_year_and_month(year, month)
        while month > 12
          month -= 12
          year += 1
        end
        while month < 1
          month += 12
          year -= 1
        end
        
        [year, month]
      end

      @this_year, @this_month = adjust_year_and_month(@this_year, @this_month)
  
      @first_day = Date.new(@this_year, @this_month, 1)
      @last_day = @first_day.end_of_month
  
      @wlast_day = (@first_day + (6-@first_day.wday))
      @week_period = (@first_day..@wlast_day)
  
      @wlast_day2 = ((@wlast_day + 1) + 6)
      @week_period2 = ((@wlast_day + 1)..@wlast_day2)
  
      @wlast_day3 = ((@wlast_day2 + 1) + 6)
      @week_period3 = ((@wlast_day2 + 1)..@wlast_day3)
  
      @wlast_day4 = ((@wlast_day3 + 1) + 6)
      @week_period4 = ((@wlast_day3 + 1)..@wlast_day4)
  
      @wlast_day5 = ((@wlast_day4 + 1) + 6)
      @week_period5 = ((@wlast_day4 + 1)..@wlast_day5)
  
      @wlast_day6 = ((@wlast_day5 + 1) + 6)
      @week_period6 = ((@wlast_day5 + 1)..@wlast_day6)
  
      @posts = {}
      
      (@first_day..@last_day).each do |day|
        @posts[day.day] = Post.where(user_id: @user.id, year: @this_year, month: @this_month, date: day.day)
      end
  
      @timestamps = {}

      (@first_day..@last_day).each do |day|
        @timestamps[day.day] = Timestamp.where(user_id: @user.id, year: @this_year, month: @this_month, date: day.day)
      end
  
    end
  
    def index
        @x = 0
        if params[:n].present?
          @x = params[:n].to_i + 1
        elsif params[:p].present?
          @x = params[:p].to_i - 1
        end

        @users = User.all.order(id: "ASC")

        now = Date.today
        @month = now.month + @x
        @year = now.year

        if @month > 12
          @month -= 12
          @year += 1
        elsif @month < 1
          @month += 12
          @year -= 1
        end

        @addedSchedule = Post.where(year: @year, month: @month)
        @addedTimestamp = Timestamp.where(year: @year, month: @month, day_off: [false, nil]) # アップデート前はday_offの値を持たないのでnilを許容
    end
end
  
