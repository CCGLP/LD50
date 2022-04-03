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
export (Curve) var witchTimeCurve
export var witchTimeMaxTime:= 30.0
export var witchTime = 0.8
export (PackedScene) var particlesParry
export (PackedScene) var killArea
var gameTimer:= 0.0
var invencible = false
var invencibleTime:= 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gameTimer += delta
	parryTimer += delta
	if (invencible):
		invencibleTime+=delta
		if (invencibleTime > 0.5):
			invencible = false
			invencibleTime = 0.0
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
			Engine.time_scale = 1.0
			particlesNew.position = self.position
			particlesNew.emitting = true
			get_node("/root/Game").add_child(particlesNew)
			var rand = RandomNumberGenerator.new()
			rand.randomize()
			$GoodParry.pitch_scale = rand.randf_range(0.9,1.1)
			$GoodParry.play()
			parryTween.interpolate_property($ParryTimer, "scale", Vector2(1.0, 1.0), Vector2(0.0, 0.0), 0.4)
		parryTween.start()
		var copyBulletsToParry = bulletsToParry.duplicate()
		for id in copyBulletsToParry:
			parryTimer= timeToRechargeParry+1	
			Bullets.call_deferred("release_bullet", id)
			bulletsToParry.erase(id)
			var powerupToUp = Bullets.get_kit_from_bullet(id).data["powerup"]	
			onPowerup(powerupToUp)


	pass



func onPowerup(powerup):
	if (powerup == 1):
		health = 2
		$Square.modulate = Color(0.0, 0.0, 1.0, 1.0)
	elif(powerup == 2):
		$explosion.play()
		invencible = true
		var kill = killArea.instance()
		bulletsToParry.clear()
		kill.position = self.position
		get_node("/root/Game").add_child(kill)
	pass
func _on_HitArea_area_shape_entered(area_rid:RID, area:Area2D, area_shape_index:int, local_shape_index:int):
	if (!invencible):
		if  !Bullets.is_bullet_existing(area_rid, area_shape_index):
			return
		health -= 1
		if (health == 0):
			emit_signal("gameOver")
		var bullet_id = Bullets.get_bullet_from_shape(area_rid, area_shape_index)
		$WarningParry.visible = false
		Bullets.call_deferred("release_bullet", bullet_id)
		call_deferred("_removeFromBullets", bullet_id)
		Engine.time_scale = 1.0
		$Square.modulate = Color(1.0,1.0,1.0,1.0)
		
	pass # Replace with function body.

func _removeFromBullets(bullet_id):
	bulletsToParry.erase(bullet_id)
	pass

func _on_ParryArea_area_shape_entered(area_rid:RID, area:Area2D, area_shape_index:int, local_shape_index:int):
	if (!invencible):
		if !Bullets.is_bullet_existing(area_rid, area_shape_index):
			return
		
		if (parryTimer > timeToRechargeParry):
			$WarningParry.visible = true
		var bullet_id = Bullets.get_bullet_from_shape(area_rid, area_shape_index)
		witchTime = witchTimeCurve.interpolate(gameTimer/witchTimeMaxTime)
		Engine.time_scale = witchTime
		bulletsToParry.append(bullet_id)
		pass

func _on_ParryArea_area_shape_exited(area_rid:RID, area:Area2D, area_shape_index:int, local_shape_index:int):
	if (!invencible):
		if !Bullets.is_bullet_existing(area_rid, area_shape_index):
			return
		$WarningParry.visible = false
		var bullet_id = Bullets.get_bullet_from_shape(area_rid, area_shape_index)
		Engine.time_scale = 1.0
		call_deferred("_removeFromBullets", bullet_id)
	pass




func _on_Window_windowChanged(size):
	self.position = size/2
	pass # Replace with function body.
