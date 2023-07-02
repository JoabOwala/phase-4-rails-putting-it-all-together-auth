class UsersController < ApplicationController
    before_action :require_login, only: [:show]

    def create
        user = User.new(user_params)
        if user.save
            session[:user_id] = user.id
            render json: user, only: [:id, :username, :image_url, :bio], status: :created
        else
            render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
    end

    def show
        user = User.find(session[:user_id])
        render json: user, only: [:id, :username, :image_url, :bio], status: :ok
    end

    private

    def user_params
        params.require(:user).permit(:username, :password, :image_url, :bio)
    end

    def require_login
        unless session[:user_id]
        render json: { error: 'Unauthorized' }, status: :unauthorized
    end
    end
end
