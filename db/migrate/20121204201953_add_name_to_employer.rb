class AddNameToEmployer < ActiveRecord::Migration
  def change
    add_column :employers, :name, :string
  end
end
