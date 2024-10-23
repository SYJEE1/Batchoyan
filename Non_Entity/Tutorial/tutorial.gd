extends Node2D

@onready var fps_label: Label = $Camera2D/FPSLabel

signal updates_completed

func _ready() -> void:
	Engine.max_fps = 60
	var max_total_customers: int = 15
	var quota: float = 1000
	var stage_num: String = "1"
	var customers: int = 15
	var order_function = "tutorial"
	Global.get_max_customers(customers)
	Global.get_quota(quota)
	Global.get_stage_num(stage_num)
	Global.get_order(order_function)
	print("tutorial customers: ", customers)
	print("tutorial order: ", order_function)
	emit_signal("updates_completed")

func _process(delta: float) -> void:
	fps_label.text = "FPS: %d" %Engine.get_frames_per_second()
