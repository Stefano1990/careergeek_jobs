class View < ActiveRecord::Base
  attr_accessible :ip, :job_id

  belongs_to      :job

  validates       :job_id, :ip, presence: true
end
