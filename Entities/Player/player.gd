extends CharacterBody2D

# editable variables
var speed := 75
var accel := 5 
var detected_station = []
var detected_item = []

# node paths
@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var animation_player: AnimationPlayer = $PlayerSprite/AnimationPlayer
@onready var carried_item: RigidBody2D

# interact variables
var has_item : bool
@onready var interact_area: Area2D = $InteractArea
@onready var interact_collision: CollisionShape2D = $InteractArea/InteractCollision
@onready var ray_1: RayCast2D = $InteractArea/InteractCollision/Ray1


# this functions runs once 
func _ready() -> void:
	animation_player.play("idle_down")
	if self.has_node("Item") == false:
		has_item = false
		interact_collision.disabled = false
	else: 
		has_item = true
		interact_collision.disabled = true
	
# this functions runs every frame
func _physics_process(delta: float) -> void:
	
	# gets input within the 4 axis (-x, +x, -y, +y)
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	# movement formula
	movement(input_direction, delta)
	
	#interact
	interact(input_direction, delta)
	
	# when colliding with another collision, player slides.
	move_and_slide()
	
	
func movement(input_direction, delta) -> void:
	
	# movement smoothness formula
	velocity = lerp(velocity, input_direction * speed, delta * accel)

	# do this if player stops moving
	if input_direction == Vector2.ZERO:
		velocity = lerp(velocity, Vector2.ZERO, delta * accel) # apply friction
		animation_player.speed_scale = lerp(animation_player.speed_scale, 1.0, delta* accel)
		if animation_player.current_animation == "walk_left": animation_player.play("idle_left")
		elif animation_player.current_animation == "walk_right": animation_player.play("idle_right")
		elif animation_player.current_animation == "walk_up": animation_player.play("idle_up")
		elif animation_player.current_animation == "walk_down": animation_player.play("idle_down")

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
		

	if has_item == false: # if no item
		speed = 60
		
		if detected_station.size() > 0 and detected_station[0].takes_item == false:
			if detected_station[0].has_method("glow"): detected_station[0].glow()
			if Input.is_action_just_pressed("interact"):
				pass
		
		if detected_item.size() > 0 and detected_item[0].get_parent().is_carried == false:
			detected_item[0].get_parent().glow()
			if Input.is_action_just_pressed("interact"):
				
				if detected_station.size() > 0: # if there is station nearby
					detected_item[0].global_position
					detected_station.push_back(detected_station[0])
					detected_station.pop_front()
					
				carried_item = detected_item[0].get_parent()
				carried_item.pickup()
				carried_item.is_carried = true
				has_item = true
				
			
	
	
	
	else: # if has item 
		speed = 50
		carried_item.global_position = lerp(carried_item.global_position, interact_collision.global_position, delta * accel * 3)
		if detected_station.size() > 0 and detected_station[0].takes_item == true:
			if detected_station[0].has_method("glow"): detected_station[0].glow()
			if Input.is_action_just_pressed("interact"):
				carried_item.putdown()
				var distance = carried_item.global_position.distance_to(detected_station[0].global_position) * 22
				var impulse = carried_item.global_position.direction_to(detected_station[0].global_position) * distance
				carried_item.apply_impulse(impulse, Vector2(0,0))
				detected_station[0].interact(carried_item)
				carried_item.is_carried = false
				carried_item = null 
				has_item = false
			
			
			
			
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
	
