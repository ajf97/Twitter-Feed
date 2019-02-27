class SessionsController < ApplicationController
  
  def new
  end

  def create
    
    # Seleccionamos el email del usuario de la base de datos
    user = User.find_by(email: params[:session][:email].downcase)
    
    if user && user.authenticate(params[:session][:password])
      # Loguearse y mostrar la página del usuario
      log_in user
      redirect_to user
    else
      # Error
      flash.now[:danger] = 'Usuario o contraseña incorrectos'
      render 'new'
    end

  end

  def destroy
    log_out
    redirect_to root_url
  end 


end
