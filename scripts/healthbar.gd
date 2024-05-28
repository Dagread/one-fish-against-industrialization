extends Node2D

class_name HealthBar

var health : HealthComponent
@onready var fill = $HealthFill
var fill_max_height = 154

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fill.scale.y = health.health / health.MAX_HEALTH * fill_max_height
