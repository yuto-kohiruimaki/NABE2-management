class PostsController < ApplicationController
    before_action :authenticate_user!

    def new
        @userName = current_user.name
        @userId = current_user.id
    end

    def create
        post = Post.new(year:params[:year], month:params[:month], date:params[:date], place:params[:place], name:params[:name], desc:params[:desc], user_id:current_user.id)
        post.save
        redirect_to root_path
    end

    def edit
        @post = Post.find_by(id: params[:id])
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
        redirect_to root_path
    end
end