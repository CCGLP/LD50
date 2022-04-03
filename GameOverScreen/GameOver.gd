extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var globals = get_node("/root/Globals")
var timer:= 0.0
export var timeToControl = 1.0

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
		timer = -1000.0
		get_tree().change_scene("res://MenuScreen/MenuScreen.tscn")
	pass



# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_size(Vector2(1280,720))
	OS.set_window_position((OS.get_screen_size() / 2) - Vector2(720, 360)) 
	if (globals.actualTime > globals.highScore):
		globals.highScore = globals.actualTime
		globals.save()
	$ScoreText.text = "Final time: " + str(globals.actualTime).pad_decimals(2) +"s"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer+= delta
	pass
