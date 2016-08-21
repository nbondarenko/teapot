class User < ApplicationRecord
  validates :email, :password, presence: { message: " must be filled" }
  validates :token, presence: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, uniqueness: { message: "%{value}  already exists" }
end
