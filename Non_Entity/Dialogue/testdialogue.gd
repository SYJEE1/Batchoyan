extends BaseDialogueTestScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var balloon = load("res://Non_Entity/Dialogue/balloon.tscn").instantiate() 
	get_tree().current_scene.add_child(balloon)
	balloon.start(resource, title)