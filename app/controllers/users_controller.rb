class UsersController < ApplicationController
  before_action :prepare_users_index, only: :index
  before_action :set_user, only: :show
  before_action :authorize_user!, only: :show

  def show
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

    @this_year, @this_month = adjust_year_and_month(@this_year, @this_month)

    @first_day = Date.new(@this_year, @this_month, 1)
    @last_day = @first_day.end_of_month

    @work_plan = WorkPlan.find_by(user: @user, period: @first_day)
    @planned_working_days = @work_plan&.planned_working_days
    @monthly_timestamp_count = Timestamp.where(user_id: @user.id,
                                               work_date: @first_day..@last_day,
                                               day_off: [false, nil]).count

    @wlast_day = (@first_day + (6 - @first_day.wday))
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
      date = Date.new(@this_year, @this_month, day.day)
      @posts[day.day] = Post.where(user_id: @user.id, post_date: date)
    end

    @timestamps = {}

    (@first_day..@last_day).each do |day|
      date = Date.new(@this_year, @this_month, day.day)
      @timestamps[day.day] = Timestamp.where(user_id: @user.id, work_date: date)
    end
  end

  def index; end

  private

  def prepare_users_index
    @x = 0
    if params[:n].present?
      @x = params[:n].to_i + 1
    elsif params[:p].present?
      @x = params[:p].to_i - 1
    end

    @users = user_listing_scope.order(id: :asc)

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

    period_start = Date.new(@year, @month, 1)
    period_end = period_start.end_of_month

    @work_plans = WorkPlan.for_period(period_start).index_by(&:user_id)
    @addedTimestamp = Timestamp.where(work_date: period_start..period_end, day_off: [false, nil]) # アップデート前はday_offの値を持たないのでnilを許容
  end

  def set_user
    relation = current_user&.admin? ? User : User.active
    @user = relation.find(params[:id])
  end

  def authorize_user!
    return if current_user.admin? || current_user == @user

    return redirect_to user_path(id: current_user.id, year: params[:year] || @abs_this_year, month: params[:month] || @abs_this_month), alert: "権限がありません。"
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

  def user_listing_scope
    User.active
  end
end
