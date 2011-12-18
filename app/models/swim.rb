class Swim < ActiveRecord::Base
  scope :measured, where("seconds > 0 and distance > 0")
  scope :training, where(:race => [nil, false])
  scope :races, where(:race => true)
  scope :distance, lambda { |distance| where(:distance => distance) }

  before_create :calculate_rate

  def self.average_time
    (average("rate").to_f * 1000).to_i
  end

  def self.average_distance_per_month
    months = grouped_by_month
    total = 0.0

    months.each do |month, swims|
      total += swims.inject(0) { |sum, s| sum += s.distance }
    end

    return total.to_f / months.length
  end

  def self.total_distance_per_month
    months = grouped_by_month
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
    months = Swim.measured.training.grouped_by_month
    months.map do |month, swims|
      [ month, Swim.where(id: swims).average_time ]
    end
  end

  def self.grouped_by_month
    months = all.group_by { |s| s.date.strftime("%B %Y") }
    months.sort_by { |month, swims| Date.strptime(month, "%B %Y") }
  end

  def self.best_training_swim(distance = nil)
    conds = "race is null and seconds > 0"
    if distance
      conds += " and distance = #{ distance }"
    end

    return  Swim.first(:conditions => [ conds ],
                       :order => "seconds / distance")
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
        :time => (s.seconds.to_i > 0 ? s.seconds.to_time : ""),
        :notes => s.notes || ""
      }
    end
    return res
  end

  def seconds_per_m
    seconds.to_f / distance.to_f
  end

  def minutes_per_km
    res = seconds_per_m * 1000.0 / 60.0
    return res if res.to_i != 0
  end

  def measured?
    Swim.measured.exists?(id: id)
  end

  def calculate_rate
    self.rate = (seconds.to_f / distance.to_f) if measured?
  end

  def to_time
    (seconds ? seconds.to_time : "")
  end

end
