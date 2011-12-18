class RemoveMinutes < ActiveRecord::Migration
  def up
    Swim.measured.all.each do |s|
      total = (s.minutes * 60) + s.seconds
      s.update_attributes!(seconds: total)
    end

    remove_column :swims, :minutes
  end

  def down
    add_column :swims, :minutes, :integer
  end
end
