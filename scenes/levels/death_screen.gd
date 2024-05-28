extends Node2D

signal level_changed(level_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("deathscreen")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_button_down():
	emit_signal("level_changed", "tutorial")


func _on_exit_button_down():
	emit_signal("level_changed", "main_menu")
