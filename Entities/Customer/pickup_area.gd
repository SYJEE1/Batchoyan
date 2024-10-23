extends Area2D

var has_item = Global.get_item_state()  # Flag to track if the player is holding an item
var player_scene: PackedScene
var frame = Global.send_current_frame()
var animation = Global.send_current_animation()

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	Global.connect("item_state_changed", Callable(self, "_on_item_state_changed"))

func _on_body_entered(carried_item: RigidBody2D):
	if carried_item is RigidBody2D:
		var item = carried_item.item_sprite
		if is_item_matching(carried_item):
			if not has_item:
				get_parent().finish_order()
			else:
				print("Player is holding the item")
		else:
			print("Player is holding an incorrect item: ", carried_item.name)

func _on_item_state_changed(state: bool):
	has_item = state  # Update the has_item state based on the player's signal

func is_item_matching(match: RigidBody2D) -> bool:
	print(match.custom_item_type, " ", frame)
	return match.custom_item_type == "bowl_super" and frame == 2
