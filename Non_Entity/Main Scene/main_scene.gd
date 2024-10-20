extends Node2D

@onready var fps_label: Label = $Camera2D/FPSLabel
var game_running : bool
func _ready() -> void:
	Engine.max_fps = 60

func _process(delta: float) -> void:
	if game_running:
		fps_label.text = "FPS: %d" %Engine.get_frames_per_second()
	else:
		if Input.is_action_just_pressed("func1"):
			DialogueManager.show_example_dialogue_balloon(load("res://Entities/tutorial.dialogue"),"start")
			game_running = true 
		
	
