extends Control



func _on_play_pressed():
	get_tree().changed_scene_to_file("res://Environment/main_scene.tscn")


func _on_option_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
