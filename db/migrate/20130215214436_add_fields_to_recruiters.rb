class AddFieldsToRecruiters < ActiveRecord::Migration
  def change
    add_column :recruiters, :surname, :string
    add_column :recruiters, :city, :string
    add_column :recruiters, :country, :string
    add_column :recruiters, :company, :string
  end
end
