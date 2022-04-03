extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer:= 0.0
export (PackedScene) var particles
# Called when the node enters the scene tree for the first time.
func _ready():
	var newParticles = particles.instance()
	newParticles.position = self.position
	newParticles.emitting = true
	get_node("/root/Game").add_child(newParticles)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer+= delta
	if (timer > 0.3):
		queue_free()
	pass


func _on_KillArea_area_shape_entered(area_rid:RID, area:Area2D, area_shape_index:int, local_shape_index:int):
	if  !Bullets.is_bullet_existing(area_rid, area_shape_index):
		return
	var bullet_id = Bullets.get_bullet_from_shape(area_rid, area_shape_index)	
	Bullets.call_deferred("release_bullet", bullet_id)
	pass # Replace with function body.
