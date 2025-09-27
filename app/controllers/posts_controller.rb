class PostsController < ApplicationController
    before_action :set_post, only: [:edit, :update, :destroy, :show]
    before_action :authorize_post!, only: [:edit, :update, :destroy, :show]

    def new
        @userName = current_user.name
        @userId = current_user.id
    end

    def create
        # 日付を作成
        post_date = Date.new(params[:year].to_i, params[:month].to_i, params[:date].to_i)
        
        post = Post.new(
            post_date: post_date,
            place: params[:place],
            name: params[:name],
            desc: params[:desc],
            user_id: current_user.id
        )
        post.save
        redirect_to index_path
    end

    def edit
        @month = @post.post_date&.month
        @date = @post.post_date&.day
    end

    def update
        @post.place = params[:place]
        @post.name = params[:name]
        @post.desc = params[:desc]
        @post.save
        redirect_to index_path
    end

    def destroy
        @post.destroy
        redirect_to index_path
    end

    def show
        @month = @post.post_date&.month
        @date = @post.post_date&.day
        @place = @post.place
        @name = @post.name
        @desc = @post.desc
        @userId = @post.user_id
    end

    private

    def set_post
        @post = Post.find_by(id: params[:id])
        return if @post.present?

        return redirect_to index_path(year: @abs_this_year, month: @abs_this_month), alert: "対象のデータが見つかりません。"
    end

    def authorize_post!
        return if current_user.admin? || @post&.user_id == current_user.id

        return redirect_to index_path(year: @abs_this_year, month: @abs_this_month), alert: "権限がありません。"
    end
end
