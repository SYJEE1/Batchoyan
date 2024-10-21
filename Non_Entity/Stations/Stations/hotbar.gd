extends Node2D

@onready var hotbar_animation: AnimationPlayer = $HotbarAnimation

var selection: int = clampi(3,1,5)

func _ready() -> void:
	hotbar_animation.play("enter")	
	



func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent):
	if event.is_action_pressed("interact"): 
		hotbar_animation.play("exit")
		return selection
	if event.is_action_pressed("hotbarleft"): selection -= 1
	if event.is_action_pressed("hotbarright"): selection += 1
	
		
	if selection == 1: hotbar_animation.play("1")
	if selection == 2: hotbar_animation.play("2")
	if selection == 3: hotbar_animation.play("3")
	if selection == 4: hotbar_animation.play("4")
	if selection == 5: hotbar_animation.play("5")
