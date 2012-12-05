class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :email, :name, :password, :password_confirmation

  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end
end
