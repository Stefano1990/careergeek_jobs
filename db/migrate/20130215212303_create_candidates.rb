class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :city
      t.string :country
      t.string :linkedin
      t.string :password_digest

      t.timestamps
    end
  end
end
