module Admin
  class DashboardController < ApplicationController
    before_action :require_admin!

    def show; end
  end
end
