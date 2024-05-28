extends Node2D

class_name HealthComponent

signal health_depleted

@export var MAX_HEALTH := 10
var health : float
@export var play_hurt_sound = true

func _ready():
	health = MAX_HEALTH

func take_damage(amount):
	health -= amount
	if health < 0:
		health = 0
		health_depleted.emit()
	print("😭😭😭 Pain")
	if(play_hurt_sound):
		$AudioStreamPlayer.play()
	return health <= 0
	
func heal(amount):
	health += amount
	if(health > MAX_HEALTH):
		health = MAX_HEALTH
