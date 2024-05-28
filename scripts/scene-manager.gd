extends Node

# 
# Items:
# 0 - simple explosion
# 1 - healing blast
# 2 - oil spill
# 3 - roe
# 

@export var CURRENT_SPEED = Vector2(0.0, 0.0)
@export var BOSS: Node2D

@export var WAVE_AMPLITUDE = 0

@export var attack_master_scene : PackedScene

var talking = false

@export var dialogue : Node2D

@export var portal : PackedScene
@export var next_scene : String

@onready var attack_father = $AttackManager

var attack_master

enum CurrentState {
  START,
  BATTLE,
  DIALOGUE,
  END
}

var state = CurrentState.START

signal level_changed(level_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	attack_master = attack_master_scene.instantiate() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(state != CurrentState.BATTLE):
		execute(["attack", "clear"])
	if(state == CurrentState.BATTLE):
		if(WAVE_AMPLITUDE > 0):
			do_waves(delta)

func do_waves(delta):
	%background.texture_offset += CURRENT_SPEED*delta
	CURRENT_SPEED.y = sin(Time.get_ticks_msec()/500.0)*WAVE_AMPLITUDE

func execute(instruction):
	for i in range(len(instruction)):
		match instruction[i]:
			"scene":
				i += 1
				emit_signal("level_changed", instruction[i])
			"waves":
				WAVE_AMPLITUDE = instruction[i+1]
				i += 1
			"current":
				CURRENT_SPEED = Vector2(instruction[i+1], instruction[i+2])
				i += 2
			"set_state":
				i += 1
				match instruction[i].to_lower():
					"start":
						state = CurrentState.START
					"battle":
						state = CurrentState.BATTLE
					"dialogue":
						state = CurrentState.DIALOGUE
					"end":
						state = CurrentState.END
			"kill_boss":
				var position_new = BOSS.position
				BOSS.die()
				var new_portal = portal.instantiate()
				new_portal.position = position_new
				new_portal.new_scene = next_scene
				new_portal.connect("level_changed", Callable(self, "load_scene"))
				$Camera2D.add_child(new_portal)
			"attack":
				i += 1
				match instruction[i]:
					"tutorial":
						var new_attack = attack_master.tutorial.instantiate()
						new_attack.global_position = Vector2(0, 0)
						$AttackManager.add_child(new_attack)
					"oil1":
						var new_attack = attack_master.oil1.instantiate()
						new_attack.global_position = Vector2(0, 0)
						$AttackManager.add_child(new_attack)
					"oil2":
						var new_attack = attack_master.oil2.instantiate()
						new_attack.global_position = Vector2(0, 0)
						$AttackManager.add_child(new_attack)
					"oil3":
						var new_attack = attack_master.oil3.instantiate()
						new_attack.global_position = Vector2(0, 0)
						$AttackManager.add_child(new_attack)
					"ham1":
						var new_attack = attack_master.ham.instantiate()
						new_attack.global_position = Vector2(0, 0)
						$AttackManager.add_child(new_attack)
					"clear":
						for j in range(0, $AttackManager.get_child_count()):
							$AttackManager.get_child(j).queue_free()

func load_scene(name):
	emit_signal("level_changed", name)
