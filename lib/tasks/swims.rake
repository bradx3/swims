task :add_swim => :environment do
  Swim.create!(date: ENV["date"] || Date.today,
               notes: ENV["notes"].gsub("[", "(").gsub("]", ")"),
               race: ENV["race"],
               distance: ENV["distance"],
               seconds: ENV["seconds"])
end
