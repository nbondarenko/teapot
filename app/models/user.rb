##
#This class represents user model
class User < ApplicationRecord
  validates :email, presence: { message: " must be filled" }
  validates :password, presence: { message: " must be filled" }
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validates :email, uniqueness: { message: "%{value}  already exists" }
end
