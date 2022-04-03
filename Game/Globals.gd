extends Node

var actualTime := 0.0
var highScore := 0.0

func save():
    var save_dict = {
        "actualTime": actualTime,
        "highScore": highScore
    }
    var save_game = File.new()
    save_game.open("user://save.save", File.WRITE)
    save_game.store_line(to_json(save_dict))
    save_game.close()
    pass

func load():
    var save_game = File.new()
    if !save_game.file_exists("user://save.save"):
        return 
    save_game.open("user://save.save", File.READ)
    var data = parse_json(save_game.get_line())
    actualTime = data["actualTime"]
    highScore = data["highScore"]
    save_game.close()
    pass