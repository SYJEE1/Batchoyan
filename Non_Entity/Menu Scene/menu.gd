extends Control  # Change this to the appropriate type (e.g., Control, Node2D)

func _on_play_pressed() -> void:
	var loadingScreen = load("res://Non_Entity/Loading Screen/loading_screen.tscn")
	get_tree().change_scene_to_packed(loadingScreen)
