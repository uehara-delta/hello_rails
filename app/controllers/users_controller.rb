class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def update
    user = current_user
    if user.update(user_params)
      flash[:notice] = I18n.t('flash.user_updated')
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :sex, :avatar, :remove_avatar)
  end

end
