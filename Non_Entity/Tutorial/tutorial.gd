extends Node2D

@onready var fps_label: Label = $Camera2D/FPSLabel

signal updates_completed

func _ready() -> void:
	Engine.max_fps = 60
	
	var quota: float = 1000
	var stage_num: String = "1"
	print("this is stage: ", stage_num)
	Global.get_quota(quota)
	Global.get_stage_num(stage_num)
	emit_signal("updates_completed")

func _process(delta: float) -> void:
	fps_label.text = "FPS: %d" %Engine.get_frames_per_second()
	
