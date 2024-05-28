extends Node2D

signal level_changed(level_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	emit_signal("level_changed", "tutorial")



func _on_exit_pressed():
	get_tree().quit() 
