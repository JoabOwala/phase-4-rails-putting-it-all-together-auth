class RecipesController < ApplicationController
    def index
    if session[:user_id]
      recipes = Recipe.includes(:user).all
      render json: recipes, include: { user: { only: [:id, :username, :image_url, :bio] } }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def create
    if session[:user_id]
      user = User.find(session[:user_id])
      recipe = user.recipes.build(recipe_params)
      if recipe.save
        render json: recipe, include: { user: { only: [:id, :username, :image_url, :bio] } }, status: :created
      else
        render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :instructions, :minutes_to_complete)
  end
end
