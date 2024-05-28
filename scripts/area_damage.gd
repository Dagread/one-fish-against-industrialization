extends Area2D

@export var attack_damage := 10.0 # damage per second

var attacked_bodies = []

func _process(delta):
	for body in attacked_bodies:
		if(body.damage(delta*attack_damage)):
			attacked_bodies.erase(body)


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print("🧏‍♂️🗣️ Entered")
	if area.has_method("damage"):
		attacked_bodies.append(area)


func _on_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area in attacked_bodies:
		attacked_bodies.erase(area)
