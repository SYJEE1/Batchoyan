# In Global.gd
extends Node

# For Scores

var amount_paid: float = 0.0
var total_earnings: float = 0.0
var new_quota: float = 0.0
var stage_number: String = ""
var tutorial_scene = preload("res://Non_Entity/Tutorial/Tutorial.tscn")
signal amount_paid_changed(new_amount: float)
signal new_stage_number(stage_number: String)

func _ready () -> void:
	var tutorial = tutorial_scene.instantiate()
	get_tree().current_scene.add_child(tutorial)
	tutorial.connect("updates_completed", Callable (self, "_on_updates_completed"))
	tutorial.queue_free()  

func _on_updates_completed() -> void:
	print("Updates completed in tutorial.gd. Now executing dependent functions.")
	send_quota()  # Call the function to send the quota
	send_stage_num()  # Call the function to send the stage number

func get_quota(quota: float):
	if quota != new_quota:  # Only update if there's a change
		new_quota = quota
		return new_quota

func send_quota() -> float:
	return new_quota

# Getting Stage Number
func get_stage_num(new_stage_num: String):
	if new_stage_num != stage_number:
		print ("new stage: ", stage_number)
		stage_number = new_stage_num
		emit_signal("new_stage_number", stage_number)
		return new_stage_num

func send_stage_num() -> String:
	print ("stage to send: ", stage_number)
	return stage_number


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
var current_item_animation: String = ""

func get_current_animation(new_animation: String):
	current_item_animation = new_animation
	return current_item_animation

func send_current_animation() -> String:
	return current_item_animation

func get_current_frame(new_frame: float):
	current_item_frame = new_frame
	return current_item_frame

func send_current_frame() -> int:
	return current_item_frame
