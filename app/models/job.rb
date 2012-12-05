class Job < ActiveRecord::Base
  attr_accessor :new_employer
  attr_accessible :about_this_job, :requirements, :how_to_apply, :location, :start_date, :title, :new_employer, :category_id

  belongs_to      :employer
  belongs_to      :category
  has_many        :views, dependent: :destroy

  validates       :title, :employer, :location, :start_date, :about_this_job, :requirements, :how_to_apply, :category, presence: true

  def increase_view_counter(ip)
    unless views.find_by_ip(ip)
     views.create!(ip: ip)
    end
  end
end
