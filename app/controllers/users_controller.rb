class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @title = "Sign up"
  end

  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end

end
