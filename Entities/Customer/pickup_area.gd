extends Area2D

var has_item = Global.get_item_state()  # Flag to track if the player is holding an item
var player_scene: PackedScene

#idk about these two damn
var custom_item_type: String = "bowl_super"
var custom_frame: int = 1  

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	Global.connect("item_state_changed", Callable(self, "_on_item_state_changed"))

func _on_body_entered(body: RigidBody2D):
	if body is RigidBody2D:
		if is_item_matching(body):
			if not has_item:
				body.queue_free()  # Remove the item from the scene
				get_parent().finish_order()
			else:
				print("Player is holding the item")
		else:
			print("Player is holding an incorrect item: ", body.name)

func _on_item_state_changed(state: bool):
	has_item = state  # Update the has_item state based on the player's signal

func is_item_matching(item: RigidBody2D) -> bool:
	# temporary bowl_super
	if item.custom_item_type == "bowl_super" and item.custom_frame == 1:
		return true  # The item matches the order
	else:
		return false  # The item doesn't match
