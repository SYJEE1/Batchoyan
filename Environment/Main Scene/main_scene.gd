extends Node2D

@onready var fps_label: Label = $Camera2D/FPSLabel
@onready var path_follow = $CustomerPath/PathFollow2D
var customer_path = preload("res://Entities/Customer/customer_path.tscn")
var spawn_interval = 1.0
var time_since_last_spawn = 0.0
var max_customers = 5
var current_customers = 0

func _ready() -> void:
	Engine.max_fps = 60
	pass

func _process(delta):
	time_since_last_spawn += delta
	if time_since_last_spawn >= spawn_interval and current_customers < max_customers:
		spawn_customer()
		time_since_last_spawn = 0.0

func spawn_customer():
	# Create a new customer instance
	var customer = customer_path.instantiate()
	
	# Set the progress ratio of the customer using PathFollow2D
	customer.get_node("PathFollow2D").progress_ratio = path_follow.progress_ratio
	
	# Add the customer to the scene
	add_child(customer)
	
	# Connect to the finished_path signal
	customer.get_node("PathFollow2D").connect("finished_path", Callable(self, "_on_PathFollow2D_finished_path"))
	
	# Increment the customer count
	current_customers += 1

func _on_PathFollow2D_finished_path():
	# Find the customer that emitted the signal
	var customer = get_child(get_child_count() - 1)
	
	# Decrement the customer count
	current_customers -= 1
	# Remove the customer from the scene
	remove_child(customer)
	customer.queue_free()
