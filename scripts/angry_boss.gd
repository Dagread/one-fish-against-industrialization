extends Node2D

@export var health : HealthComponent
@export var scene_manager : Node2D
var dialogue

var wave1 = false
var wave2 = false
var wave3 = false
var died = false
var first_timer = true

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_manager = %SceneManager.scene_manager
	dialogue = scene_manager.dialogue
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(health.health <= 0 and not died):
		dialogue.start_dialogue("death")
		died = true
	if(health.health <= 150 and not wave1):
		dialogue.start_dialogue("stage2")
		wave1 = true
	if(health.health <= 100 and not wave2):
		dialogue.start_dialogue("stage3")
		wave2 = true
	if(health.health <= 50 and not wave3):
		dialogue.start_dialogue("stage4")
		wave3 = true

func die():
	$AudioStreamPlayer.play()
	
func leave():
	dialogue.start_dialogue("leave")
	
func destroy():
	queue_free()

func _on_audio_stream_player_finished():
	destroy()
