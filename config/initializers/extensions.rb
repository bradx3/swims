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
