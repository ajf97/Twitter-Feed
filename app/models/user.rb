class User

  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  field :name, type: String
  field :email, type: String
  field :password_digest, type: String 

   # Añadimos contraseña segura para el usuario 
   has_secure_password
   validates :password, presence: true, length: { minimum: 7 }

  # Convertimos el email a minúsculas para evitar case senstive en los índices

  before_save { self.email = email.downcase }

  #Expresión regular para aceptar direcciones de correo válidas

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  presence: true, length: { maximum: 50 } # obligamos a que no esté en blanco 
  validates :email, presence: true, length: { maximum: 255 }, format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive:false }

  # Creamos índices para garantizar la unicidad en el nivel de base de datos

  index({ name: 1 }, { unique: true })
  index({ email: 1 }, { unique: true })

 


end
