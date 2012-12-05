class Employer < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation
  has_secure_password

  validates       :email, :password, :password_confirmation, presence: true

  has_many        :jobs

  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end
end
