class AddSwimsTable < ActiveRecord::Migration
  def up
    create_table :swims do |t|
      t.date :date
      t.integer :distance
      t.integer :minutes
      t.integer :seconds
      t.boolean :race
      t.text :notes
    end
  end

  def down
    drop_table :swims
  end
end
