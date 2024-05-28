extends Node2D

var speed = 0
@export var displaying = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not displaying:
		position +=  speed*delta
		if position.length() > 500.0:
			destroy()
		
func destroy():
	print("🔫🧊🔫DESTPRY BASTARD!!!! POG")
	queue_free()
