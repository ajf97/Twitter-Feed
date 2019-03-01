module SessionsHelper

  #Establecer una cookie temporal 
  def log_in(user)
    session[:user_id] = user.id
  end

  # Obtener los datos del usuario 
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id["$oid"])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id["$oid"])
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end


  #Comprobamos si el usuario está logueado para realizar acciones en la vista 
  def logged_in?
    !current_user.nil?
  end

  # Función que finaliza la sesión
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end 

  # Recordar usuario en sesión persistente 
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Olvidar usuario
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end 

  # Comprobar si un usuario es igual que el usuario actual
  def current_user?(user)
    user == current_user
  end

  # Redirigir a la localización almacenada 
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Almacenar la url para ser accedida porsteriormente 
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end



end
