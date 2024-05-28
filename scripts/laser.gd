extends Node2D

@export var speed: float = 200.0
var direction: Vector2
@onready var destruction_timer: Timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func launch(target_position: Vector2):
	direction = (target_position - global_position).normalized()
	rotation = direction.angle() + PI / 2
	show()
	destruction_timer.start(2.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction != Vector2.ZERO:
		position += direction * speed * delta

func _on_weapon_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	destroy()
	


func destroy():
	print("🔫🔫🔫COLLISION!!!! POG")
	queue_free()


func _on_timer_timeout():
	destroy()
