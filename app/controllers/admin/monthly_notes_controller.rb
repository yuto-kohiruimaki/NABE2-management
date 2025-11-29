module Admin
  class MonthlyNotesController < ApplicationController
    before_action :require_admin!

    def update
      year = params[:year].to_i
      month = params[:month].to_i
      month_string = format("%04d-%02d", year, month)

      monthly_note = MonthlyNote.find_or_initialize_by(month: month_string)

      if params[:monthly_note][:description].blank?
        if monthly_note.persisted? && monthly_note.destroy
          redirect_to admin_users_path(year: year, month: month), notice: "月次メモを削除しました。"
        else
          redirect_to admin_users_path(year: year, month: month), notice: "月次メモはありません。"
        end
      else
        monthly_note.description = params[:monthly_note][:description]
        if monthly_note.save
          redirect_to admin_users_path(year: year, month: month), notice: "月次メモを保存しました。"
        else
          redirect_to admin_users_path(year: year, month: month), alert: "月次メモの保存に失敗しました。"
        end
      end
    end

    private

    def require_admin!
      unless current_user&.admin?
        redirect_to root_path, alert: "管理者権限が必要です。"
      end
    end
  end
end
