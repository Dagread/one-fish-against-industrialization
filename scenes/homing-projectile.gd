extends Node2D

@export var speed = 170.0
@export var randomness = 0

func _ready():
	print("🎯🚅🐂 Im coming for ya")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_global_mouse_position()
	var direction = mouse_position - global_position
	direction += Vector2(randf_range(-randomness, randomness), randf_range(-randomness, randomness))
	direction = direction.normalized() * speed
	position +=  direction*delta
	if position.length() > 500.0:
		destroy()
		
func destroy():
	print("🔫🧊🔫DESTPRY BASTARD!!!! POG")
	queue_free()
