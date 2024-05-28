extends CharacterBody2D

const DASH_VELOCITY = 600.0
const FRICTION = 0.9
const VELOCITY_DASH_TRESHOLD = 200.0

var environment_velocity = Vector2(0,0)
var fish_velocity = Vector2(0,0)

@export var can_shoot = true
@export var ProjectileScene: PackedScene

enum CurrentState {
  IDLE,
  DAMAGING,
  DASHING
}

var state = CurrentState.IDLE
var damage_multiplier = 0

@onready var animated_sprite = $AnimatedSprite2D

@export var healthbar : HealthBar

var scene_manager : Node2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var animation_status

func _ready():
	scene_manager = %SceneManager.scene_manager
	print(scene_manager)
	if healthbar:
		healthbar.health = $HealthComponent
	resume_game()

func _physics_process(delta):
	if(scene_manager):
		process_controls()
		move_and_slide()

func process_controls():
	# Handle dash.
	var mouse_position = get_global_mouse_position()
	if(scene_manager.CURRENT_SPEED.length() > 0):
		environment_velocity = -scene_manager.CURRENT_SPEED*Vector2(36, 27)
	else:
		environment_velocity = Vector2(0,0)
	if Input.is_action_just_pressed("player_dash"):
		$AudioStreamPlayer.play()
		var direction = mouse_position - position
		direction = direction.normalized()
		fish_velocity += direction * DASH_VELOCITY
		
		if(scene_manager.state == scene_manager.CurrentState.BATTLE):
			var projectile = ProjectileScene.instantiate()
			projectile.global_position = global_position + direction.normalized()*50
			projectile.speed = DASH_VELOCITY
			get_tree().root.add_child(projectile)
			projectile.launch(global_position+direction.normalized()*60)
	
	fish_velocity = fish_velocity * FRICTION
	if(scene_manager.state != scene_manager.CurrentState.BATTLE):
		environment_velocity = Vector2(0,0)
	velocity = environment_velocity + fish_velocity
	
	if(mouse_position.x > position.x):
		animated_sprite.flip_h = true
		var look_position = mouse_position - position
		animated_sprite.look_at(position + look_position)
	else:
		animated_sprite.flip_h = false
		var look_position = position - mouse_position
		animated_sprite.look_at(position + look_position)

func update_state():
	if(damage_multiplier > 0):
		state = CurrentState.DAMAGING
		return

	if((fish_velocity).length() > VELOCITY_DASH_TRESHOLD):
		state = CurrentState.DASHING
	else:
		state = CurrentState.IDLE

func _process(delta):
	update_state()
	animate()

func animate():
	if(state == CurrentState.DAMAGING):
		animated_sprite.play("damage")
	elif(state == CurrentState.DASHING):
		animated_sprite.play("dash")
	else:
		animated_sprite.play("idle")

func pause_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func resume_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_health_component_health_depleted():
	print("👻👻👻 YOU FYMKING DIED LOL")
	scene_manager.load_scene("death")

func enable_shooting():
	can_shoot = true
