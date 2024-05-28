extends Area2D

@export var attack_damage := 4.0

func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.has_method("damage"):
		area.damage(attack_damage)
