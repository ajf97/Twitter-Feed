class User

  attr_accessor :remember_token

  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  field :name, type: String
  field :email, type: String
  field :password_digest, type: String 
  field :remember_digest, type: String
  field :admin, type: Boolean, default:false

   # Añadimos contraseña segura para el usuario 
   has_secure_password
   validates :password, presence: true, length: { minimum: 7 }, allow_nil: true

  # Convertimos el email a minúsculas para evitar case senstive en los índices

  before_save { self.email = email.downcase }

  #Expresión regular para aceptar direcciones de correo válidas

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  presence: true, length: { maximum: 50 } # obligamos a que no esté en blanco 
  validates :email, presence: true, length: { maximum: 255 }, format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive:false }

  # Creamos índices para garantizar la unicidad en el nivel de base de datos

  index({ name: 1 }, { unique: true })
  index({ email: 1 }, { unique: true })

   # Devuelve el hash de un string 
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Generador de tokens
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Recordar el usuario en la base de datos para sesiones persistentes
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Comprobar si el token coincide 
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end


  # Olvidar cookie 
  def forget
    update_attribute(:remember_digest,nil)
  end






end


 



