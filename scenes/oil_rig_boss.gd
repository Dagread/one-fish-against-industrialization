extends Node2D

@export var health : HealthComponent
@export var scene_manager : Node2D
var dialogue

var asked_third = false
var asked_third2 = false
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
		get_tree().get_root().get_child(0).killed_oil_rig = true
		dialogue.start_dialogue("death")
		died = true
	if(health.health <= 125 and not asked_third):
		dialogue.start_dialogue("dying")
		asked_third = true
	if(health.health <= 50 and not asked_third2):
		dialogue.start_dialogue("almost")
		asked_third2 = true
	if(scene_manager.state != scene_manager.CurrentState.BATTLE):
		$Timer.paused = true
	else:
		$Timer.paused = false
	
func die():
	$AudioStreamPlayer.play()
	
func leave():
	dialogue.start_dialogue("leave")
	
func destroy():
	queue_free()

func _on_audio_stream_player_finished():
	destroy()


func _on_timer_timeout():
	if(not first_timer and health.health == health.MAX_HEALTH):
		leave()
	
	if(first_timer and health.health == health.MAX_HEALTH):
		dialogue.start_dialogue("what")
		$Timer.start()
		$Timer.paused = true
		first_timer = false
