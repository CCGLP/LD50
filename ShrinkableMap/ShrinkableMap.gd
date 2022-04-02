extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var shrink_speed := 0.1
export var shrink_minScale := 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (self.scale.x > shrink_minScale):
		self.scale = self.scale - Vector2.ONE * (delta * shrink_speed)
	pass
