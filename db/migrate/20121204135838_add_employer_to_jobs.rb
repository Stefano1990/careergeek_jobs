class AddEmployerToJobs < ActiveRecord::Migration
  def up
    add_column      :jobs, :employer_id, :integer
  end

  def down
    remove_column   :jobs, :employer_id, :integer
  end
end
