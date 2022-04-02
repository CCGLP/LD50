extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var timeToControl = 2
var timer:= 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	_globalInput()
	pass

func _unhandled_input(event):
	_globalInput()
	pass

func _globalInput():
	if (timer > timeToControl):
		print("Hola")
		get_tree().change_scene("res://Game/Game.tscn")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer+= delta
	pass
