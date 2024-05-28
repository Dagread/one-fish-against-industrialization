extends Node2D

var answer_fields

var dialogue_data = {}
var current_node = {}
var player_sentiment = 0
@export var json_file: JSON
var dialogue_question = false
var scene_manager : Node2D

const TYPING_SLOW = 10 # characters per second
const TYPING_FAST = 24 # characters per second
var typing_time = 0
var previous_characters = 0

@export var icon : Texture2D

func _ready():
	scene_manager = %SceneManager.scene_manager
	$Speech/Portrait.texture = icon
	answer_fields = [$Respond/Option1, $Respond/Option2, $Respond/Option3, $Respond/Option4]
	if json_file:
		dialogue_data = json_file.data
	else:
		print("Error: No JSON file selected.")
	visible = false
	$Timer.start()

func start_dialogue(node_name):
	visible = true
	scene_manager.execute(["set_state", "dialogue"])
	print("🗣️🔊🗣️ Dialogue code: " + node_name)
	current_node = dialogue_data["dialogue"][node_name]
	progress_dialogue()

func progress_dialogue():
	if "text" in current_node:
		say(current_node["text"], current_node["speed"])
		dialogue_question = false
	if "answers" in current_node:
		var answers = []
		var weights = []
		for answer in current_node["answers"]:
			answers.append(answer["text"])
			weights.append(answer["sentiment_change"])
		ask(current_node["text"], answers, weights, current_node["speed"])
		dialogue_question = true

func on_choice_selected(choice_index):
	var selected_answer = current_node["answers"][choice_index]
	player_sentiment += selected_answer["sentiment_change"]
	if selected_answer["next"]:
		start_dialogue(selected_answer["next"])
	else:
		end_dialogue()

func start_typing(text, speed):
	$Respond/Question.visible_ratio = 0
	$Speech/Text.visible_ratio = 0
	previous_characters = 0
	if(speed == 1):
		typing_time = text.length() / TYPING_FAST
	else:
		typing_time = text.length() / TYPING_SLOW

func ask(question, answers, weights, speed):
	$Respond/Question.text = question
	for i in range(4):
		if i < len(answers):
			answer_fields[i].text = str(i+1) + ") " + answers[i]
		else:
			answer_fields[i].text = ""
	start_typing(question, speed)
	$Speech.visible = false
	$Respond.visible = true

func say(text, speed):
	$Speech/Text.text = text
	start_typing(text, speed)
	$Speech.visible = true
	$Respond.visible = false

func _process(delta):
	if(scene_manager):
		if(scene_manager.state == scene_manager.CurrentState.DIALOGUE):
			dialogue_loop(delta)

func dialogue_loop(delta):
	var new_characters = 0
	var visible_ratio = 0
	if(dialogue_question):
		$Respond/Question.visible_ratio += delta / typing_time
		visible_ratio = $Respond/Question.visible_ratio
		new_characters = $Respond/Question.visible_characters
	else:
		$Speech/Text.visible_ratio += delta / typing_time
		visible_ratio = $Speech/Text.visible_ratio
		new_characters = $Speech/Text.visible_characters
	
	if previous_characters < new_characters:
		var last_char = ""
		if(dialogue_question):
			last_char = $Respond/Question.text.substr(new_characters - 1, 1)
		else:
			last_char = $Speech/Text.text.substr(new_characters - 1, 1)
		
		if not is_space_or_punctuation(last_char):
			$AudioStreamPlayer.play()
		
		previous_characters = new_characters
		
	if current_node.has("answers") and current_node.has("text"):
		if Input.is_action_just_pressed("ui_accept"):
			if(visible_ratio < 1):
				$Speech/Text.visible_ratio = 1
				$Respond/Question.visible_ratio = 1
		for i in range(4):
			if Input.is_action_just_pressed("option_" + str(i + 1)):
				on_choice_selected(i)
	elif current_node.has("text"):
		if Input.is_action_just_pressed("ui_accept"):
			if(visible_ratio < 1):
				$Speech/Text.visible_ratio = 1
				$Respond/Question.visible_ratio = 1
			else:
				if current_node["next"]:
					start_dialogue(current_node["next"])
				else:
					end_dialogue()

func end_dialogue():
	if(current_node != null):
		visible = false
		if(current_node.has("action")):
			scene_manager.execute(current_node["action"])
		say("End of dialogue.", 1)
		dialogue_question = false
		scene_manager.talking = false
	current_node == null

func is_space_or_punctuation(char):
	var punctuation = [".", ",", "!", "?", ";", ":", "-", " "]
	return char in punctuation


func _on_timer_timeout():
	start_dialogue("start")
