extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mod = -1
export var speedToFade = 2
var fadeValue = 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fadeValue = fadeValue + (speedToFade * delta * mod)
	if (fadeValue > 1):
		mod = -1 
	elif (fadeValue < 0):
		mod = 1
	self.modulate = Color(1,1,1,fadeValue)
	pass
