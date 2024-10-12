extends CharacterBody2D

const speed := 75
const accel := 5

@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var animation_player: AnimationPlayer = $PlayerSprite/AnimationPlayer
@onready var animation_tree: AnimationTree = $PlayerSprite/AnimationTree

# this functions runs once 
func _ready() -> void:
	animation_player.play("idle_down")

# this functions runs every frame
func _physics_process(delta: float) -> void:
	
	# gets input within the 4 axis (+x, -x, +y, -y)
	var input_direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	print(animation_player.speed_scale)
	
	# movement formula
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
		if Input.is_action_pressed("left") and not Input.is_action_pressed("right"): animation_player.play("walk_left")
		elif Input.is_action_pressed("right") and not Input.is_action_pressed("left"): animation_player.play("walk_right")
		elif Input.is_action_pressed("up"): animation_player.play("walk_up")
		elif Input.is_action_pressed("down"): animation_player.play("walk_down")
	
	
	# when colliding with another collision, player slides.
	move_and_slide()
