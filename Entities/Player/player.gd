extends CharacterBody2D

<<<<<<< HEAD
# editable variables
var speed := 50
var accel := 5 
var has_item := true
var is_facing_interactable := false
var facing_this_node : Node2D

# scenes to instantiate
const ITEM_SCENE = preload("res://Non_Entity/Items/Item.tscn")

# node paths of player scene
@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var animation_player: AnimationPlayer = $PlayerSprite/AnimationPlayer
@onready var item_animation: AnimationPlayer = $ItemAnimation

@onready var animation_tree: AnimationTree = $PlayerSprite/AnimationTree
@onready var item: AnimatedSprite2D = $Item
@onready var interact_area: Area2D = $InteractArea
@onready var down_collision: CollisionShape2D = $InteractArea/DownCollision
@onready var up_collision: CollisionShape2D = $InteractArea/UpCollision
@onready var left_collision: CollisionShape2D = $InteractArea/LeftCollision
@onready var right_collision: CollisionShape2D = $InteractArea/RightCollision

=======
const speed := 50
const accel := 5

@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var animation_player: AnimationPlayer = $PlayerSprite/AnimationPlayer
@onready var animation_tree: AnimationTree = $PlayerSprite/AnimationTree
>>>>>>> main

# this functions runs once 
func _ready() -> void:
	animation_player.play("idle_down")
<<<<<<< HEAD
<<<<<<< HEAD
	if self.has_node("Item") == false:
		has_item = false
		interact_collision.disabled = false
	else: 
		has_item = true
		interact_collision.disabled = true
=======
	#down_collision.disabled = false
>>>>>>> parent of c468b66 (feat: interaction)
	
=======

>>>>>>> main
# this functions runs every frame
func _physics_process(delta: float) -> void:
	
	# gets input within the 4 axis (+x, -x, +y, -y)
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	# movement formula
<<<<<<< HEAD
	movement(input_direction, delta)
	
	#interact
	interact()
	
	# when colliding with another collision, player slides.
	move_and_slide()
	
	
func movement(input_direction, delta) -> void:
	
	# movement smoothness formula
=======
>>>>>>> main
	velocity = lerp(velocity, input_direction * speed, delta * accel)
	
	# do this if player stops moving
	if input_direction == Vector2.ZERO:
		velocity = lerp(velocity, Vector2.ZERO, delta * accel) # apply friction
		animation_player.speed_scale = lerp(animation_player.speed_scale, 1.0, delta* accel)
		if animation_player.current_animation == "walk_left": animation_player.play("idle_left")
		elif animation_player.current_animation == "walk_right": animation_player.play("idle_right")
		elif animation_player.current_animation == "walk_up": animation_player.play("idle_up")
		elif animation_player.current_animation == "walk_down": animation_player.play("idle_down")

<<<<<<< HEAD
<<<<<<< HEAD
	else:
		if abs(input_direction.x) > abs(input_direction.y):
			if input_direction.x > 0: animation_player.play("walk_right")
			else: animation_player.play("walk_left")
		elif abs(input_direction.x) < abs(input_direction.y):
			if input_direction.y > 0: animation_player.play("walk_down")
			else: animation_player.play("walk_up")
		
		# speeds animation via velocity
		animation_player.speed_scale = (( abs(velocity.x) + abs(velocity.y)) /30)
		
		# moves interact_collision (purple thing) based on movement
		if (input_direction.x > .5 or input_direction.x < -.5) or (input_direction.y > .5 or input_direction.y < -.5): 
			interact_collision.position = lerp(interact_collision.position, Vector2(
			input_direction.x * 8, 
			input_direction.y * 6), 
			delta * accel * 5)
		
				
func interact(input_direction, delta) -> void:
	#print("detected Item:", detected_item)
	#print("detected Station:", detected_station)
	
	
	if detected_item.size() > 0: detected_item.sort_custom(_sort_by_distance_from_player)
	if detected_station.size() > 0: detected_station.sort_custom(_sort_by_distance_from_player)
=======
	else: # if player is moving
		animation_player.speed_scale = (( abs(velocity.x) + abs(velocity.y)) /30) # speeds animation via velocity
		if input_direction.x < 0:
			animation_player.play("walk_left")
			item_animation.play("left")
		elif input_direction.x > 0: 
			animation_player.play("walk_right")
			item_animation.play("right")
		elif input_direction.y < 0: 
			animation_player.play("walk_up")
			item_animation.play("up")
		elif input_direction.y > 0: 
			animation_player.play("walk_down")
			item_animation.play("down")
>>>>>>> parent of c468b66 (feat: interaction)
		
func disable_interact_collision(right : bool, left : bool, down : bool, up : bool) -> void:
	right_collision.disabled = right
	left_collision.disabled = left
	down_collision.disabled = down
	up_collision.disabled = up

func interact() -> void:
	if is_facing_interactable == true:
		if item.animation == "noitem": 
			pass # facing_this_node = glow the surface
		elif Input.is_action_just_pressed("interact"):
			
			var instance = ITEM_SCENE.instantiate()
			instance.global_position = to_global(facing_this_node.local_to_map(global_position))
			owner.add_child(instance)
			
			print("global position of item: ", instance.global_position)
			#item.set_animation("noitem")
			
			
<<<<<<< HEAD
			
			
			#if detected_station[0].has_item == true:
				#detected_station.push_back(detected_station[0])
				#detected_station.pop_front()




func _sort_by_distance_from_player(area1, area2):
	var area1_to_player = interact_collision.global_position.distance_to(area1.global_position)
	var area2_to_player = interact_collision.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _on_itementered(area: Area2D) -> void:
	if area.get_collision_layer() == 8 and has_item == false: detected_item.push_back(area)
	if area.get_collision_layer() == 16: detected_station.push_back(area)
func _on_itemexited(area: Area2D) -> void: 
	if area.collision_layer == 8: detected_item.erase(area)
	if area.collision_layer == 16: detected_station.erase(area)
	
=======
	else: # if player is moving
		animation_player.speed_scale = (( abs(velocity.x) + abs(velocity.y)) /30) # speeds animation via velocity
		if Input.is_action_pressed("left") and not Input.is_action_pressed("right"): animation_player.play("walk_left")
		elif Input.is_action_pressed("right") and not Input.is_action_pressed("left"): animation_player.play("walk_right")
		elif Input.is_action_pressed("up"): animation_player.play("walk_up")
		elif Input.is_action_pressed("down"): animation_player.play("walk_down")
	
	
	# when colliding with another collision, player slides.
	move_and_slide()
>>>>>>> main
=======
func _on_bodyentered_InteractArea(body: Node2D) -> void: 
	is_facing_interactable = true
	facing_this_node = body
func _on_bodyexited_InteractArea(body: Node2D) -> void: 
	is_facing_interactable = false
	#facing_this_node = body
>>>>>>> parent of c468b66 (feat: interaction)
