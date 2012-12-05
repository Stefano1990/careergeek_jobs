class ChangeJobDetails < ActiveRecord::Migration
  def up
    remove_column       :jobs, :description
    add_column          :jobs, :about_this_job, :text
    add_column          :jobs, :requirements, :text
    add_column          :jobs, :how_to_apply, :text
  end

  def down
    remove_column       :jobs, :about_this_job
    remove_column       :jobs, :requirements
    remove_column       :jobs, :how_to_apply
  end
end
