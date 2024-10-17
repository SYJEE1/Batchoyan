extends Control

var path_follow
var is_at_stop_point = false

func _ready():
	path_follow = get_parent()
	set_process_input(true)  # Enable input processing
	add_to_group("customers")  # Add to group for easy access

func _process(delta):
	# Check if the customer is at a stop point
	is_at_stop_point = path_follow.progress_ratio in path_follow.stop_points

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = get_global_mouse_position()
		var customer_pos = get_global_position()
		var customer_size = get_rect().size
		if mouse_pos.x > customer_pos.x and mouse_pos.x < customer_pos.x + customer_size.x and mouse_pos.y > customer_pos.y and mouse_pos.y < customer_pos.y + customer_size.y:
			if path_follow.progress_ratio in path_follow.stop_points and not path_follow.has_placed_order:
				path_follow.has_placed_order = true
				path_follow.is_order_placed_manually = true
				print("Order placed manually")
				path_follow.occupy_stop_point()
	elif event is InputEventMouseMotion:
		if path_follow.progress_ratio in path_follow.stop_points and not path_follow.has_placed_order:
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)  # Change cursor to pointing hand
		else:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)  # Change cursor back to arrow
