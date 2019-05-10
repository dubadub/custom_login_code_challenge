class User < ApplicationRecord

  validates :handle, uniqueness: true

  def password
    @password ||= BCrypt::Password.new(encrypted_password)
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)

    self.encrypted_password = @password
  end

end
