extends Area2D

const area_type := &"station"
var takes_item: bool = false
var tilemap_glow : TileMapLayer

var hotbar_active : bool = false
var selection: int = clampi(3,1,5)
var item : RigidBody2D
var new_item : RigidBody2D
var hotbar_peek_anim : AnimationPlayer
var hotbar_select_anim : AnimationPlayer
var player : CharacterBody2D
var drink_name: Label

const ITEM = preload("res://Non_Entity/Items/Item.tscn")
const HOTBAR = preload("res://Non_Entity/Stations/Stations/hotbar.tscn")




func _ready() -> void:
	tilemap_glow.modulate = Color(1,1,1,0)
	
	var hotbar_instance = HOTBAR.instantiate()
	hotbar_instance.global_position = global_position
	add_child(hotbar_instance)
	
	hotbar_peek_anim = hotbar_instance.get_child(0)
	hotbar_select_anim = hotbar_instance.get_child(1)
	drink_name = hotbar_instance.get_child(2)
	hotbar_peek_anim.play("RESET")
	
func interact(carried_item):
	new_item = ITEM.instantiate()
	new_item.global_position = global_position
	if selection == 1: new_item.set_item(&"c3", 1)
	if selection == 2: new_item.set_item(&"water", 1)
	if selection == 3: new_item.set_item(&"loyal", 1)
	if selection == 4: new_item.set_item(&"sprike", 1)
	if selection == 5: new_item.set_item(&"cora", 1)
	#new_item.apply_impulse(Vector2(randf_range(1,-1)*50,randf_range(2,3)*100),Vector2.ZERO)
	get_tree().root.add_child(new_item)
	return new_item
	
	
func hotbar_peek(action : bool):
	if action == true: 
		hotbar_active = true
		hotbar_peek_anim.play("enter")
		print("playing enter")
		#print("entering")
	else: 
		hotbar_peek_anim.play("exit")
		hotbar_active = false
		#print("exiting")
		print("playing exit")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hotbarleft"): selection -= 1
	if event.is_action_pressed("hotbarright"): selection += 1
	
	if selection == 0: selection = 5
	elif selection == 6: selection = 1
		
	if selection == 1: hotbar_select_anim.play("1"); drink_name.text = "C3"
	elif selection == 2: hotbar_select_anim.play("2"); drink_name.text = "Water"
	elif selection == 3: hotbar_select_anim.play("3"); drink_name.text = "Loyal"
	elif selection == 4: hotbar_select_anim.play("4"); drink_name.text = "Sprike"
	elif selection == 5: hotbar_select_anim.play("5"); drink_name.text = "Cora"

		

func glow(carried_item) -> void:
	var glow_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	glow_tween.tween_property(tilemap_glow, "modulate", Color(1,1,1,1), .1)
	unglow(glow_tween)
	
func unglow(glow_tween) -> void:
	if glow_tween.finished:
		glow_tween.tween_property(tilemap_glow, "modulate", Color(1,1,1,0), .1)
