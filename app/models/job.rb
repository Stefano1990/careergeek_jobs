class Job < ActiveRecord::Base
  attr_accessible :about_this_job, :requirements, :how_to_apply, :location, :start_date, :title, :category_id, :application_deadline, :employer

  belongs_to      :recruiter
  belongs_to      :category
  has_many        :views, dependent: :destroy

  validates       :title, :location, :application_deadline, :start_date, :about_this_job, :requirements, :how_to_apply, :category, presence: true

  def increase_view_counter(ip)
    unless views.find_by_ip(ip)
     views.create!(ip: ip)
    end
  end

  def blank_employer?
    employer_id == 0
  end
end
