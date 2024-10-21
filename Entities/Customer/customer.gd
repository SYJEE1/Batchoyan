extends CharacterBody2D

@export var spawn_point: Node2D
var is_clickable: bool = true  # Flag to determine if the customer is clickable
var order: Dictionary = {}
var order_system: Node
var timer: Timer  # Declare a member variable for the timer
var earnings_display: Node
signal removed

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load and instantiate the score scene
	var score_scene: PackedScene = load("res://Entities/Customer/Order/score.tscn")
	var score_instance: Node2D = score_scene.instantiate() as Node2D  # Get the root Node2D
	# Access the Control child node
	earnings_display = score_instance.get_node("Control") as Control  # Replace "Control" with the actual name of your Control node
	get_tree().root.add_child(score_instance)  # Add the root Node2D to the scene tree

	# Initialize the earnings display if needed
	earnings_display.add_earnings(0)  # Initialize earnings
	
	var order_system_scene: PackedScene = load("res://Entities/Customer/Order/order_system.tscn")
	order_system = order_system_scene.instantiate()
	add_child(order_system)
	order = order_system.tutorial_order()  # Call the order function
	order_system.display_order(order) 
	
	# Ensure the node is input pickable
	set_process_input(true)  
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

	# Add and start the timer
	timer = Timer.new()  # Create a new Timer instance
	timer.wait_time = 30  # Set timer for 30 seconds
	timer.one_shot = true  # Timer will only run once
	timer.connect("timeout", Callable (self, "_on_timer_timeout"))  # Connect the timeout signal
	add_child(timer)  # Add the timer as a child of the customer node
	timer.start()  # Start the timer

# Called when the mouse enters the character's area
func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

# Called when the mouse exits the character's area
func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

# Input event handling
func _input_event(_viewport: Node, event: InputEvent, shape_idx: int):
	# Check if the event is a mouse button event and if it was pressed.
	if is_clickable and event is InputEventMouseButton and event.pressed:
		# Check if the mouse click is within the bounds of the character.
		if shape_idx != -1:  # shape_idx is -1 if the click is outside the node's collision shape.
			print("Finish order")  # This line can be removed if not needed
			finish_order()  # Call the function to finish the order

# Function to finish the order and remove the customer
func finish_order():
	if order_system:
		var paid = order_system.calculate_total_price(order)  # Get the total price from order_system
		var price = 1.0  # no deduction
		
		# Use the member variable for the timer
		if timer:  # Check if the timer node is valid
			# Calculate elapsed time
			var elapsed_time = timer.wait_time - timer.time_left  # Calculate elapsed time

			# Apply discount based on the elapsed time
			if elapsed_time <= 10:
				price = 0.7  # 20% less
			elif elapsed_time <= 20:
				price = 0.8  # 30% less
			elif elapsed_time == 30:
				price = 0.0  # Set total to 0 if time is up
			# Calculate final price
			var amount_paid = paid * price
			print("Final Price: PHP", amount_paid)  # Print the final price
			
			if earnings_display:
				earnings_display.add_earnings(amount_paid)
			

		order_system.queue_free()  # Remove the order system from the scene
	print("Emitting removed signal for customer")
	emit_signal("removed", self)
	queue_free()  # Remove the customer from the scene

# Timer timeout function
func _on_timer_timeout():
	print("Time is up! The customer leaves.")
	finish_order()  # Call finish_order when the timer times out
