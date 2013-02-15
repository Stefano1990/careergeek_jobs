class Candidate < ActiveRecord::Base
  has_secure_password
  attr_accessible :city, :country, :email, :linkedin, :name, :surname, :password, :password_confirmation

  validates :city, :email, :password, :password_confirmation, :name, :surname, presence: true

  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end
end
