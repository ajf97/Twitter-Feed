module SessionsHelper

  #Establecer una cookie temporal 
  def log_in(user)
    session[:user_id] = user.id
  end

  # Obtener los datos del usuario 
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id]["$oid"])
    end
  end


  #Comprobamos si el usuario está logueado para realizar acciones en la vista 
  def logged_in?
    !current_user.nil?
  end

  # Función que finaliza la sesión
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end 


end
