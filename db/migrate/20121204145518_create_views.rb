class CreateViews < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.integer :job_id
      t.string :ip

      t.timestamps
    end
  end
end
