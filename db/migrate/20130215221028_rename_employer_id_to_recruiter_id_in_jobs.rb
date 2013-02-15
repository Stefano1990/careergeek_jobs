class RenameEmployerIdToRecruiterIdInJobs < ActiveRecord::Migration
  def up
    remove_column :jobs, :employer_id
    add_column :jobs, :recruiter_id, :integer
  end

  def down
    remove_column :jobs, :recruiter_id
    add_column :jobs, :employer_id, :integer
  end
end
