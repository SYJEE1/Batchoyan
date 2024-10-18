extends CharacterBody2D

@export var OrderPopupScene: PackedScene = preload("res://Entities/Customer/TextPopup.tscn")

var is_clickable: bool = true  # Flag to determine if the customer is clickable

# Called when the node enters the scene tree for the first time.
func _ready():
	# Ensure the node is input pickable
	set_process_input(true)  # Ensure you have a CollisionShape2D
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)

	show_order_popup()  # Show the order popup automatically

# Function to show the order popup
func show_order_popup():
	var popup_instance = OrderPopupScene.instantiate()
	get_tree().current_scene.add_child(popup_instance)

	# Get the customer's position
	var customer_position = position  # Assuming this script is on the customer node

	# Set the popup position (e.g., above the customer)
	popup_instance.position = customer_position + Vector2(10, 0)  # Adjust the offset as needed

	# Show the popup
	if popup_instance.has_method("popup_centered"):
		popup_instance.popup_centered()  # Center the popup if using PopupPanel

	# Connect the popup's "popup_hide" signal to a function to reset clickability
	popup_instance.connect("popup_hide", Callable(self, "_on_popup_hide"))

	# Disable clicking on the customer
	is_clickable = false

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
			print("take order")  # This line can be removed if not needed

# Called when the popup is hidden
func _on_popup_hide():
	is_clickable = true  # Re-enable clicking on the customer
	
