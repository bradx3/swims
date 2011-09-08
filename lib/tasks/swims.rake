task :add_swim do
  date = ENV["date"] || Date.today
  notes = ENV["notes"]
  race = ENV["race"]
  distance = ENV["distance"]
  minutes = ENV["minutes"]
  seconds = ENV["seconds"]

  puts "Date: #{date}"
  puts "Notes: #{notes}"
end
