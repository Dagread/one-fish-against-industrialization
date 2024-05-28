extends Node

@export var current_level : Node

@export var main_menu : PackedScene
@export var tutorial : PackedScene
@export var death : PackedScene
@export var oil_rig : PackedScene
@export var hamster : PackedScene

@export var evil_boss : PackedScene
@export var happy_boss : PackedScene

#@export var evil_boss1_rig : PackedScene # first meeting boss after killing only oil rig
#@export var evil_boss1_ham : PackedScene # first meeting boss after killing only hamster
#@export var final_boss : PackedScene # final boss fight
#
#@export var genocide_boss1 : PackedScene # first meeting boss after killing both oil rig and hamster
#@export var oil_rig2 : PackedScene # fighting a better oil rig
#@export var genocide_boss2 : PackedScene # meeting boss after fighting better oil rig
#@export var hamster_dad : PackedScene # fighting the hamster's dad
#@export var genocide_boss3 : PackedScene # scared boss killed in one hit
#
#@export var happy_end_boss : PackedScene # if you haven't killed anyone, plays right after hamster
#
#@export var domination_end : PackedScene # ending after only killing one enemy
@export var genocide_end : PackedScene # ending after killing everything
@export var happy_end : PackedScene # if you haven't killed anyone, plays right after hamster

var killed_oil_rig = false
var killed_hamster = false

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level.connect("level_changed", Callable(self, "handle_level_changed"))
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func handle_level_changed(next_level_name):
	print("👂👂🧏 loading new scene " + next_level_name)
	var next_level
	match next_level_name:
		"tutorial":
			next_level = tutorial.instantiate()
		"main_menu":
			next_level = main_menu.instantiate()
			killed_oil_rig = false
			killed_hamster = false
		"death":
			next_level = death.instantiate()
			killed_oil_rig = false
			killed_hamster = false
		"oil_rig":
			next_level = oil_rig.instantiate()
			killed_oil_rig = false
			killed_hamster = false
		"hamster":
			next_level = hamster.instantiate()
			killed_oil_rig = false
			killed_hamster = false
		"next":
			if(killed_oil_rig or killed_hamster):
				next_level = evil_boss.instantiate()
			else:
				next_level = happy_boss.instantiate()
		"happy_end":
			next_level = happy_end.instantiate()
			killed_oil_rig = false
			killed_hamster = false
		"evil_end":
			next_level = genocide_end.instantiate()
			killed_oil_rig = false
			killed_hamster = false
	
	if next_level:
		current_level.queue_free()
		add_child(next_level)
		next_level.connect("level_changed", Callable(self, "handle_level_changed"))
		current_level = next_level
	else:
		print("👿👿👿 Error: Unkown Scene Requested")
