class AddApplicationDeadlineToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :application_deadline, :date
  end
end
