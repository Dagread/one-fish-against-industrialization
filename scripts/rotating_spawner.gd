extends Node2D

@export var rotation_speed = 1.0 # rotations per second

func _ready():
	print("💫🛞☸️ Its spinning time")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var delta_rotation = rotation_speed * delta * TAU # TAU is 2 * PI
	rotation += delta_rotation

func disable_shooting():
	for child in get_children():
		if child.has_method("disable_shooting"):
			child.disable_shooting()

func enable_shooting():
	for child in get_children():
		if child.has_method("enable_shooting"):
			child.disable_shooting()
