extends Node2D  # Changed from PathFollow2D, as customers themselves should follow the path

@export var speed: float = 0.1
@onready var customer_scene = preload("res://Entities/Customer/customer_scene.tscn")
var is_moving: bool = false
var order_counter: int = 0  # Counter to keep track of orders
var customer_queue: Array = []  # Queue to hold customers waiting in line
var current_customer_index: int = -1  # Index of the current customer being processed
var customer_spacing: int = 50  # Adjust this value for vertical spacing between customers

signal customer_finished

func _ready():
	# Start the process of spawning customers at intervals
	spawn_customer()

func _process(delta):
	if is_moving and current_customer_index >= 0 and current_customer_index < customer_queue.size():
		var current_customer = customer_queue[current_customer_index]
		# Move the current customer towards the counter
		current_customer.position.y -= speed * delta * 100  # Move vertically upwards (towards the counter)

		# Stop when they reach the counter (y = 0)
		if current_customer.position.y <= 0:
			is_moving = false
			current_customer.position.y = 0  # Ensure exact positioning
			emit_signal("customer_finished", current_customer)  # Signal that the customer has reached the counter
			order_completed()  # Process the next customer only when the order is completed

func spawn_customer():
	var customer_instance = customer_scene.instantiate()
	print("Customer instance created: ", customer_instance)  # Debugging line
	
	# Set the order for the customer
	order_counter += 1
	customer_instance.set("order", order_counter)  # Assuming 'order' is a property in the customer scene
	print("Customer order: ", customer_instance.get("order"))  # Print the customer's order for debugging
	
	# Position the customer at the end of the queue (starting from the bottom)
	var queue_position_y = (customer_queue.size() + 1) * customer_spacing  # Space out based on the queue length
	customer_instance.position = Vector2(0, queue_position_y)
	add_child(customer_instance)  # Add the customer to the scene visually

	# Add the customer to the queue
	customer_queue.append(customer_instance)
	
	# Start processing the first customer if no one is moving
	if current_customer_index == -1 and not is_moving:
		process_next_customer()

func process_next_customer():
	current_customer_index += 1
	
	# Ensure we don't go out of bounds in the queue
	if current_customer_index < customer_queue.size():
		var next_customer = customer_queue[current_customer_index]
		print("Processing customer: ", next_customer.get("order"))
		is_moving = true  # Start moving the customer towards the counter
		
		# Ensure the rest of the queue stays still
		for i in range(current_customer_index + 1, customer_queue.size()):
			customer_queue[i].position = Vector2(0, (i - current_customer_index) * customer_spacing)

func _on_customer_finished():
	print("Customer has finished their path.")
	# Remove the finished customer from the queue
	if current_customer_index >= 0:
		customer_queue.remove_at(current_customer_index)
		current_customer_index -= 1  # Adjust index since we removed an element
	
	# Start processing the next customer in the queue
	process_next_customer()


func order_completed():
	# Logic that handles the order completion for the current customer
	var completed_customer = customer_queue[current_customer_index]
	print("Order completed for customer: ", completed_customer)
	remove_customer(completed_customer)
	
	# Only when the order is completed, process the next customer
	process_next_customer()

func remove_customer(customer):
	# Remove the customer instance from the scene
	if customer:
		customer.queue_free()
