extends CharacterBody2D

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


# this functions runs once 
func _ready() -> void:
	animation_player.play("idle_down")
	#down_collision.disabled = false
	
# this functions runs every frame
func _physics_process(delta: float) -> void:
	
	# gets input within the 4 axis (-x, +x, -y, +y)
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	# movement formula
	movement(input_direction, delta)
	
	#interact
	interact()
	
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
			
			
func _on_bodyentered_InteractArea(body: Node2D) -> void: 
	is_facing_interactable = true
	facing_this_node = body
func _on_bodyexited_InteractArea(body: Node2D) -> void: 
	is_facing_interactable = false
	#facing_this_node = body
