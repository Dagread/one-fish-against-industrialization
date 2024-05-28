extends Node2D

@export var spawn_rate = 0.5 # seconds between projectiles
@export var projectile : PackedScene
@onready var spawn_timer = $Timer
@export var bullet_speed = 100.0
var spawning = true
@export var bullet_collector : Node2D

func _ready():
	spawn_timer.wait_time = spawn_rate
	spawn_timer.start()

func disable_shooting():
	spawning = false

func enable_shooting():
	spawning = true

func _on_timer_timeout():
	if(spawning and bullet_collector):
		print("🔥🔫😭 I need mo bulles")
		var bullet = projectile.instantiate()
		bullet.global_position = global_position
		var direction = Vector2(cos(global_rotation), sin(global_rotation))
		bullet.speed = direction * bullet_speed
		bullet_collector.add_child(bullet)
	spawn_timer.start()
