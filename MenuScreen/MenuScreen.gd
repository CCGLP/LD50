extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var timeToControl = 2
onready var globals = get_node("/root/Globals")
var timer:= 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	globals.load()
	$MaxScore.text = "Max Score: " + str(globals.highScore).pad_decimals(2) + "s"
	pass # Replace with function body.

func _input(event):
	if (event is InputEventAction):
		_globalInput()
	pass

func _unhandled_input(event):
	if (event is InputEventKey || event is InputEventJoypadButton):
		_globalInput()
	pass

func _globalInput():
	if (timer > timeToControl):
		timer = -10000.0
		get_tree().change_scene("res://Game/Game.tscn")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer+= delta
	pass


func _on_ExitButton_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_HowToPlayButton_pressed():
	get_tree().change_scene("res://MenuScreen/HowToPlay.tscn")
	pass # Replace with function body.
