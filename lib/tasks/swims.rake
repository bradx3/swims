task :add_swim => :environment do
  Swim.create!(date: ENV["date"] || Date.today,
               notes: ENV["notes"],
               race: ENV["race"],
               distance: ENV["distance"],
               minutes: ENV["minutes"],
               seconds: ENV["seconds"])
end
