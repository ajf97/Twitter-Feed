require 'carrierwave/mongoid'

class Micropost

  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type:String
  field :picture, type:String

  belongs_to :user # Un micropost pertenece a un usuario
  default_scope -> { order(created_at: :desc) } # Ordena los micropost de más reciente a menos

  validates :user_id, presence: true
  validates :content, presence: true , length: {maximum: 140}
  validate :picture_size

  mount_uploader :picture, PictureUploader # Subir imágenes


  private

  # Comprueba el tamaño de la imagen
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "Debe de ser menor de  5MB")
    end
  end


  












end 