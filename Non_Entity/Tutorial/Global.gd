# In Global.gd
extends Node

# For Scores

var amount_paid: float = 0.0
var total_earnings: float = 0.0
var quota: float = 1000.0

signal amount_paid_changed(new_amount: float)

func get_quota() -> float:
	return quota

func set_amount_paid(new_amount_paid: float):
	amount_paid += new_amount_paid
	emit_signal("amount_paid_changed", amount_paid)  # Notify listeners
	print("amount paid signal")

func get_amount_paid() -> float:
	return amount_paid

# For Giving Orders to Customers

var has_item: bool = false
signal item_state_changed(state: bool) 

func update_item_state(state: bool):
	has_item = state
	emit_signal("item_state_changed", state)  # Notify listeners
	print("Global has_item updated to: ", has_item)

func get_item_state() -> bool:
	return has_item

# Getting the correct frame for orders

var current_item_frame: int = 1

func get_current_frame(new_frame: float):
	current_item_frame = new_frame
	return current_item_frame

func send_current_frame() -> int:
	return current_item_frame
