class Category < ActiveRecord::Base
  attr_accessible :name
  has_many        :jobs

  validates       :name, presence: true
end
