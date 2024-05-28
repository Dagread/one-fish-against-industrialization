extends Node2D

@export var health : HealthComponent
@export var scene_manager : Node2D
var dialogue

var asked_halfway = false
var died = false

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_manager = %SceneManager.scene_manager
	dialogue = scene_manager.dialogue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(health.health <= 0 and not died):
		dialogue.start_dialogue("death")
		died = true
	if(health.health <= 50 and not asked_halfway):
		dialogue.start_dialogue("halfway")
		asked_halfway = true

func die():
	$AudioStreamPlayer.play()
	
func leave():
	dialogue.start_dialogue("leave")
	destroy()
	
func destroy():
	queue_free()

func _on_audio_stream_player_finished():
	destroy()
