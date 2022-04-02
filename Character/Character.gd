extends RigidBody2D

signal gameOver
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed := 100.0
export var health := 1

var bulletsToParry := []

var parryTimer = 2.0
export var timeToRechargeParry = 2.0
onready var parryTween = $ParryTween
export (PackedScene) var particlesParry
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	parryTimer += delta
	if (Input.is_action_pressed("ui_down")):
		linear_velocity.y = speed  
	elif (Input.is_action_just_released("ui_down")):
		linear_velocity.y = 0
	if (Input.is_action_pressed("ui_up")):
		linear_velocity.y = -speed 
	elif(Input.is_action_just_released("ui_up")):
		linear_velocity.y = 0
	if (Input.is_action_pressed("ui_left")):
		linear_velocity.x = -speed 
	elif (Input.is_action_just_released("ui_left")):
		linear_velocity.x = 0
	if (Input.is_action_pressed("ui_right")):
		linear_velocity.x = speed 
	elif (Input.is_action_just_released("ui_right")):
		linear_velocity.x = 0
	
	
	linear_velocity = linear_velocity.normalized() *speed
	

	if (Input.is_action_just_pressed("ui_accept")):
		parry()
	pass

func parry():
	
	if (parryTimer > timeToRechargeParry):
		parryTimer = 0
		$ParryTimer.visible = true
		$WarningParry.visible = false
		$ParryTimer.scale = Vector2(1.0,1.0)
		if (bulletsToParry.size() == 0):
			$FailParry.play()
			parryTween.interpolate_property($ParryTimer, "scale", Vector2(1.0, 1.0), Vector2(0.0, 0.0), timeToRechargeParry)
		else:
			var particlesNew = particlesParry.instance()
			particlesNew.position = self.position
			particlesNew.emitting = true
			get_node("/root/Game").add_child(particlesNew)
			var rand = RandomNumberGenerator.new()
			rand.randomize()
			$GoodParry.pitch_scale = rand.randf_range(0.9,1.1)
			$GoodParry.play()
			parryTween.interpolate_property($ParryTimer, "scale", Vector2(1.0, 1.0), Vector2(0.0, 0.0), 0.4)
		parryTween.start()
		for id in bulletsToParry:
			parryTimer= timeToRechargeParry+1
			var powerupToUp = Bullets.get_kit_from_bullet(id).data["powerup"]
			onPowerup(powerupToUp)
			print(powerupToUp)
			Bullets.call_deferred("release_bullet", id)
			bulletsToParry.erase(id)
	pass



func onPowerup(powerup):
	if (powerup == 1):
		health = 2
		$Square.modulate = Color(0.0, 0.0, 1.0, 1.0)
	pass
func _on_HitArea_area_shape_entered(area_rid:RID, area:Area2D, area_shape_index:int, local_shape_index:int):
	if  !Bullets.is_bullet_existing(area_rid, area_shape_index):
		return
	health -= 1
	if (health == 0):
		emit_signal("gameOver")
	var bullet_id = Bullets.get_bullet_from_shape(area_rid, area_shape_index)
	bulletsToParry.erase(bullet_id)
	$WarningParry.visible = false
	Bullets.call_deferred("release_bullet", bullet_id)
	$Square.modulate = Color(1.0,1.0,1.0,1.0)
	
	pass # Replace with function body.

func _on_ParryArea_area_shape_entered(area_rid:RID, area:Area2D, area_shape_index:int, local_shape_index:int):
	if !Bullets.is_bullet_existing(area_rid, area_shape_index):
		return
	
	if (parryTimer > timeToRechargeParry):
		$WarningParry.visible = true
	var bullet_id = Bullets.get_bullet_from_shape(area_rid, area_shape_index)
	bulletsToParry.append(bullet_id)
	pass

func _on_ParryArea_area_shape_exited(area_rid:RID, area:Area2D, area_shape_index:int, local_shape_index:int):
	if !Bullets.is_bullet_existing(area_rid, area_shape_index):
		return
	$WarningParry.visible = false
	var bullet_id = Bullets.get_bullet_from_shape(area_rid, area_shape_index)
	bulletsToParry.erase(bullet_id)
	pass


