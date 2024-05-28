extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("READY TO KILL") # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func disable_shooting():
	for child in get_children():
		if child.has_method("disable_shooting"):
			child.disable_shooting()

func enable_shooting():
	for child in get_children():
		if child.has_method("enable_shooting"):
			child.disable_shooting()


func _on_tree_exiting():
	print("FUCKING DYING")
