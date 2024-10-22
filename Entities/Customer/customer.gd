extends CharacterBody2D

@export var spawn_point: Node2D
var order: Dictionary = {}
var order_system: Node
var timer: Timer
var nearby_item: RigidBody2D = null

signal removed
signal order_completed(amount_paid)

var audio_stream_player: AudioStreamPlayer
var spawn_sound: AudioStream
var spawn_volume_db: float = -25.0

func _ready():
	var order_system_scene: PackedScene = load("res://Entities/Customer/Order/order_system.tscn")
	order_system = order_system_scene.instantiate()
	add_child(order_system)
	order = order_system.tutorial_order()
	order_system.display_order(order)
	
	set_process_input(true)  
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

	timer = Timer.new()
	timer.wait_time = 30
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()

func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
func finish_order():
	if order_system:
		var paid = order_system.calculate_total_price(order)
		var price = 1.0

		if timer:
			var elapsed_time = timer.wait_time - timer.time_left
			if elapsed_time <= 10:
				price = 0.8
			elif elapsed_time <= 20:
				price = 0.7
			elif elapsed_time == 30:
				price = 0.0

			var amount_paid = paid * price

			# Set the amount paid in the global script
			Global.set_amount_paid(amount_paid)  # Set the amount in the global script
		order_system.queue_free()
	emit_signal("removed", self)
	queue_free()

func _on_timer_timeout():
	finish_order()
