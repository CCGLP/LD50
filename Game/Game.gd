extends Node2D

export (Resource) var bulletFollow; 
export (Resource) var bulletSimple;
export (Resource) var bulletShield; 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var bulletShieldProp := 0.05
export var bulletFollowProp := 0.2; 
export var speedBullet = 20
var timer := 0.0
var gameTimer:= 0.0
onready var globals = get_node("/root/Globals")
var timeToShoot:= 1.0

export (Curve) var timeToShootCurve
export var curveMaxTime:= 120.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _shoot():
	var random = RandomNumberGenerator.new()
	random.randomize()
	var randProp = random.randf_range(0.0,1.0)
	var windowSize = OS.get_window_size()
	var spawn_Point = Vector2(0,0)
	var randBorder = random.randi_range(0,3)
	if (randBorder == 0):
		spawn_Point.x = random.randf_range(10,windowSize.x-10)
		spawn_Point.y = 10
	elif (randBorder == 1):
		spawn_Point.x = random.randf_range(10,windowSize.x-10)
		spawn_Point.y = windowSize.y -10
	elif (randBorder == 2):
		spawn_Point.x = 10
		spawn_Point.y = random.randf_range(10,windowSize.y -10)
	elif (randBorder == 3):
		spawn_Point.x = windowSize.x -10
		spawn_Point.y = random.randf_range(10,windowSize.y-10) 
	var bullet_velocity = ($Character.position - spawn_Point).normalized() * speedBullet

	if (randProp < bulletFollowProp):
		var properties = {
			"transform" : Transform2D(global_rotation, spawn_Point),
			"velocity" : bullet_velocity,
			"target_node": $Character
		}
		Bullets.spawn_bullet(bulletFollow, properties)
	elif (randProp < bulletFollowProp + bulletShieldProp):
		var properties = {
			"transform" : Transform2D(global_rotation, spawn_Point),
			"velocity" : bullet_velocity,
		}
		Bullets.spawn_bullet(bulletShield, properties)
	else:
		var properties = {
			"transform" : Transform2D(global_rotation, spawn_Point),
			"velocity" : bullet_velocity
		}
		Bullets.spawn_bullet(bulletSimple, properties)
	
pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer+= delta
	gameTimer += delta
	timeToShoot = timeToShootCurve.interpolate(gameTimer / curveMaxTime)
	if (timer > timeToShoot):
		timer = 0.0
		_shoot()
	pass


func _on_Character_gameOver():
	timer = -100000
	globals.actualTime = gameTimer
	get_tree().change_scene("res://GameOverScreen/GameOver.tscn")
	pass # Replace with function body.
