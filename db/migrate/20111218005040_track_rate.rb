class TrackRate < ActiveRecord::Migration
  def up
    add_column :swims, :rate, :double

    Swim.measured.each do |s|
      s.calculate_rate
      s.save!
    end
  end

  def down
    remove_column :swims, :rate
  end
end
