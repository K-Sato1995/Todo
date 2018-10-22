class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string:title, null: false
      t.string:description, null: false
      t.timestamps
    end
  end
end
