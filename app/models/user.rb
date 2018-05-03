class User < ApplicationRecord
  # Encrypt password
  has_secure_password

  # Pagination
  self.per_page = 15

  # Validations
  validates_presence_of :username, :email, :password_digest
  validates_uniqueness_of :username, :email
end
