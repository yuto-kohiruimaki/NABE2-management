class PostsController < ApplicationController
    before_action :authenticate_user!

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
        @post = Post.find_by(id: params[:id])
        @month = @post.post_date&.month
        @date = @post.post_date&.day
    end

    def update
        @post = Post.find_by(id: params[:id])
        @post.place = params[:place]
        @post.name = params[:name]
        @post.desc = params[:desc]
        @post.save
        redirect_to index_path
    end

    def destroy
        post = Post.find_by(id: params[:id])
        post.destroy
        redirect_to index_path
    end

    def show
        @post = Post.find(params[:id])
        @month = @post.post_date&.month
        @date = @post.post_date&.day
        @place = @post.place
        @name = @post.name
        @desc = @post.desc
        @userId = @post.user_id
    end
end