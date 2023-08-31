class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @x = 0
    if params[:n].present?
      @x = params[:n].to_i + 1
    elsif params[:p].present?
      @x = params[:p].to_i - 1
    else
      @x = 0
    end
  
    @now = Date.today
    @wday = ["日", "月", "火", "水", "木", "金", "土"]
    @this_year = @now.year
    @this_month = @now.month + @x
  
    if @this_month > 12
      @this_month -= 12
      @this_year += 1
    elsif @this_month < 1
      @this_month += 12
      @this_year -= 1
    end
  
    @first_day = Date.new(@this_year, @this_month, 1)
    @last_day = @first_day.end_of_month
    
    @posts = {}
  
    (@first_day..@last_day).each do |day|
      @posts[day.day] = Post.where(year: @this_year, month: @this_month, date: day.day)
    end
  end
end