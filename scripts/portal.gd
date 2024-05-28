extends Area2D

var new_scene: String
var scene_manager : Node2D

signal level_changed(level_name)

func _ready():
	print("💦💧🌊 Portal Started")
	visible = false
	$Timer.start()

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if visible:
		if new_scene:
			emit_signal("level_changed", new_scene)
		else:
			print("Error: No scene assigned in the inspector.")

func _on_timer_timeout():
	$AudioStreamPlayer.play()
	visible = true
