class RenameEmployerToRecruiter < ActiveRecord::Migration
  def up
    rename_table :employers, :recruiters
  end

  def down
    rename_table :recruiters, :employers
  end
end
