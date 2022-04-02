extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var globals = get_node("/root/Globals")
var timer:= 0.0
export var timeToControl = 1.0

func _input(event):
	_globalInput()
	pass

func _unhandled_input(event):
	_globalInput()
	pass

func _globalInput():
	if (timer > timeToControl):
		get_tree().change_scene("res://MenuScreen/MenuScreen.tscn")
	pass



# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_size(Vector2(1280,720))
	OS.set_window_position((OS.get_screen_size() / 2) - Vector2(720, 360)) 
	$ScoreText.text = "Final time: " + str(globals.actualTime) +"s"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer+= delta
	pass
