class UsersController < ApplicationController
  
  # Llamar antes de cualquier acción
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy] 
  before_action :correct_user, only: [:edit, :update] 
  before_action :admin_user,    only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end 


  def show
    @user = User.find(params[:id]) # Busca el usuario en la base de datos 
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end


def create
  @user = User.new(user_params)
  if @user.save
    UserMailer.account_activation(@user).deliver_now
    flash[:info] = "Comprueba tu email para activar la cuenta"
    redirect_to root_url
  else
    render 'new'
  end
end

def edit
  @user = User.find(params[:id])
end 

def update 
  @user = User.find(params[:id])
  
  if @user.update_attributes(user_params) 
    # Se actualizan los datos correctamente 
    flash[:success] = "Actualizado correctamente"
    redirect_to @user
  else
    render 'edit' # En caso contrario volver a la página de edición
  end
end 

def destroy
  User.find(params[:id]).destroy
  flash[:success] = "User deleted"
  redirect_to users_url
end

# Indicar el número de seguidores y siguiendo de un usuario 

def following
  @title = "Following"
  @user  = User.find(params[:id])
  @users = @user.following.paginate(page: params[:page])
  render 'show_follow'
end

def followers
  @title = "Followers"
  @user  = User.find(params[:id])
  @users = @user.followers.paginate(page: params[:page])
  render 'show_follow'
end

private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end


  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end



end