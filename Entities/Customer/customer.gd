extends CharacterBody2D

var has_placed_order = false
var is_order_placed_manually = false
var order_system

signal order_placed
@onready var path_follow = get_node("CustomerPath")

func _ready():
	order_system = get_node("OrderSystem")
	
	# Connect the finished_path signal from PathFollow2D
	path_follow.connect("finished_path", Callable(self, "_on_finished_path"))

func _on_finished_path():
	if not has_placed_order:
		# Place the order when the customer reaches the stop point
		var order = order_system.stage1_order()
		order_system.display_order(order)  # Pass the order to the display_order function
		has_placed_order = true  # Set the flag to indicate the order has been placed
		emit_signal("order_placed")  # Emit signal that the order has been placed
