class Float
  def to_time
    return "" if self.nan?

    minutes = self.floor
    seconds = self - minutes
    seconds = (seconds * 60).to_i
    seconds = sprintf("%02d", seconds)

    return "#{ minutes }:#{ seconds }"
  end
end

class Fixnum
  def to_time
    minutes = self / 60
    seconds = self % 60
    "#{minutes}:#{seconds.to_s.rjust(2, "0")}"
  end
end
