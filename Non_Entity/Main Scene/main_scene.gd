extends Node2D

@onready var fps_label: Label = $Camera2D/FPSLabel

func _ready() -> void:
	Engine.max_fps = 120

func _process(delta: float) -> void:
	fps_label.text = "FPS: %d" %Engine.get_frames_per_second()
