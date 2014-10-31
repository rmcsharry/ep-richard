games = Game.all

games.each do |g|
  g.position = 999
  g.save
end

Game.find_by_name("Selfies!").insert_at(1)
Game.find_by_name("Imaginary Safari").insert_at(2)
Game.find_by_name("The Laundrette").insert_at(3)
Game.find_by_name("I am, She is").insert_at(4)
Game.find_by_name("Band Practice").insert_at(5)
Game.find_by_name("Treasure Hunt").insert_at(6)
Game.find_by_name("Stepping Stones").insert_at(7)
Game.find_by_name("Lunch time").insert_at(8)

p = Pod.find_by_name("Basil's test pod")
p.go_live_date = 1.year.ago
p.save
