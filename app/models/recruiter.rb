class Recruiter < ActiveRecord::Base
  has_secure_password
  attr_accessible :email, :password, :password_confirmation, :name, :surname, :company, :city, :country

  validates       :email, :password, :password_confirmation, :name, :surname, :company, :city, :country, presence: true
  validates       :email, :password, :password_confirmation, presence: true, on: :create

  has_many        :jobs

  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end
end
