class Swim < ActiveRecord::Base
  default_scope order(:date)

  scope :measured, conditions: [ "minutes > 0 and seconds  > 0 and distance > 0" ]
  scope :training, :conditions => { :race => [nil, false] }
  scope :races, :conditions => { :race => true }

  def self.average_time(swims)
    distance = 0.0
    seconds = 0.0

    swims.each do |s|
      distance += s.distance
      seconds += (s.minutes * 60.0) + s.seconds
    end

    res = seconds.to_f / distance.to_f
    return res * 1000.0 / 60.0
  end

  def self.average_distance_per_month
    months = swims_grouped_by_month
    total = 0.0

    months.each do |month, swims|
      total += swims.inject(0) { |sum, s| sum += s.distance }
    end

    return total.to_f / months.length
  end

  def self.total_distance_per_month
    months = swims_grouped_by_month
    months = months.map do |month, swims|
      total = swims.inject(0) { |sum, s| sum += s.distance }
      [ month, total ]
    end

    return months
  end

  def self.best_distance_month
    months = total_distance_per_month.sort_by { |month, total| total }
    return months.last
  end

  def self.average_times_by_month
    counted_swims = Swim.measured.training.all
    months = swims_grouped_by_month

    months = months.map do |month, swims|
      to_count = swims.select { |s| counted_swims.include?(s) }
      [ month, average_time(to_count) ]
    end
    return months
  end

  def self.swims_grouped_by_month
    months = Swim.all.group_by { |s| s.date.strftime("%B %Y") }
    months = months.sort_by { |month, swims| Date.strptime(month, "%B %Y") }
    return months
  end
  
  def self.best_training_swim(distance = nil)
    conds = "race is null and minutes > 0" 
    if distance
      conds += " and distance = #{ distance }"
    end

    return  Swim.first(:conditions => [ conds ],
                       :order => "(minutes * 60) + seconds / distance")
  end

  def self.minutes_per_km
    measured.all.map do |s|
      [ s.date.to_time.to_i * 1000, s.minutes_per_km ]
    end
  end

  def minutes_per_km
    measured.all.map do |s|
      [ s.date.to_time.to_i * 1000, s.minutes_per_km ]
    end
  end

  def self.distances
    all.map do |s|
      [ s.date.to_time.to_i * 1000, s.distance / 1000.0 ]
    end
  end

  def self.notes
    res = {}
    all.each do |s|
      res[s.date.to_time.to_i * 1000] = {
        :date => s.date.strftime("%d/%m/%y"),
        :distance => (s.distance / 1000.0).round(2),
        :time => "#{ s.minutes }:#{ s.seconds }",
        :notes => s.notes || ""
      }
    end
    return res
  end

  def total_seconds
    (minutes * 60) + seconds if minutes and seconds
  end

  def seconds_per_m
    total_seconds.to_f / distance.to_f
  end

  def minutes_per_km
    res = seconds_per_m * 1000.0 / 60.0
    return res if res.to_i != 0
  end

end
