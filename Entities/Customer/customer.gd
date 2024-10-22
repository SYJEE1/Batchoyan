# In Customer.gd
extends CharacterBody2D

@export var spawn_point: Node2D
var is_clickable: bool = true
var order: Dictionary = {}
var order_system: Node
var timer: Timer

signal removed
signal order_completed(amount_paid)

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
	timer.connect("timeout", Callable (self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()

func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _input_event(_viewport: Node, event: InputEvent, shape_idx: int):
	if is_clickable and event is InputEventMouseButton and event.pressed:
		if shape_idx != -1:
			print("Finish order")
			finish_order()

func finish_order():
	if order_system:
		var paid = order_system.calculate_total_price(order)
		print("Total price calculated: ", paid)
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
			print("Final Price: PHP", amount_paid)
			
			# Set the amount paid in the global script
			Global.set_amount_paid(amount_paid)  # Set the amount in the global script

		order_system.queue_free()
	print("Emitting removed signal for customer")
	emit_signal("removed", self)
	queue_free()

func _on_timer_timeout():
	print("Time is up! The customer leaves.")
	finish_order()
