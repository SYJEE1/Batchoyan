extends Control



func _on_play_pressed():
	get_tree().change_scene_to_file("res://Non_Entity/Tutorial/Tutorial.tscn")


func _on_option_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
