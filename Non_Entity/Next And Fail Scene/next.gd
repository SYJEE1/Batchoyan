extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_stage_pressed() -> void:
#add the next scene to the ""
	get_tree().change_scene_to_file("res://Non_Entity/Tutorial/Tutorial.tscn")



func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Environment/menu.tscn")


func _on_prev_stage_pressed() -> void:
#add the previous scene to the ""
	get_tree().change_scene_to_file("res://Non_Entity/Tutorial/Tutorial.tscn")
