class User < ApplicationRecord

  validates :handle, uniqueness: true

end
