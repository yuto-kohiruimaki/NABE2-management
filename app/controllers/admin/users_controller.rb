module Admin
  class UsersController < ::UsersController
    before_action :require_admin!
    before_action :set_admin_user, only: :toggle_status
    before_action :load_monthly_note, only: :index

    def toggle_status
      desired_status = ActiveModel::Type::Boolean.new.cast(user_status_params[:is_deleted])
      year = params[:year].presence || @abs_this_year
      month = params[:month].presence || @abs_this_month

      if @user.update(is_deleted: desired_status)
        status_label = desired_status ? "無効" : "有効"
        redirect_to admin_users_path(year: year, month: month), notice: "#{@user.name} を#{status_label}に変更しました。"
      else
        redirect_to admin_users_path(year: year, month: month), alert: "ステータスの更新に失敗しました。"
      end
    end

    private

    def user_listing_scope
      User.all
    end

    def set_admin_user
      @user = User.find(params[:id])
    end

    def user_status_params
      params.require(:user).permit(:is_deleted)
    end

    def load_monthly_note
      month_string = format("%04d-%02d", @year, @month)
      @monthly_note = MonthlyNote.find_or_initialize_by(month: month_string)
    end
  end
end
