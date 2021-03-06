class User < ApplicationRecord

  define_attribute_method :password

  validates :handle, presence: true, uniqueness: true
  validates :password, presence: true

  def password
    @password ||= begin
      BCrypt::Password.new(encrypted_password) if encrypted_password
    end
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)

    self.encrypted_password = @password
  end

end
