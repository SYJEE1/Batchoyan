extends CharacterBody2D

var is_clickable: bool = true  # Flag to determine if the customer is clickable
var order: Dictionary = {}
var order_system: Node
@export var spawn_point: Node2D

signal removed

# Called when the node enters the scene tree for the first time.
func _ready():
	var order_system_scene: PackedScene = load("res://Entities/Customer/Order/order_system.tscn")
	order_system = order_system_scene.instantiate()
	add_child(order_system)
	order = order_system.tutorial_order()  # Call the order function
	order_system.display_order(order) 
	
	# Ensure the node is input pickable
	set_process_input(true)  
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

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
		order_system.queue_free()  # Remove the order system from the scene
	print("Emitting removed signal for customer")
	emit_signal("removed", self)
	queue_free()  # Remove the customer from the scene
