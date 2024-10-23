extends Control


func resume():
	get_tree().pause = false
	$AnimationTree.play_backwards("blur")
func pause():
	get_tree().pause = true
	$AnimationTree.play("blur")
func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().pause == false:
		pause()
	if Input.is_action_just_pressed("esc") and get_tree().pause == true:
		resume()
		

# Called when the node enters the scene tree for the first time.
func _on_resume_pressed():
	resume()

func _on_quit_pressed():
	get_tree().quit()

func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()
	
func _process(delta):
	testEsc()
