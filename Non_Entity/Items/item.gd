extends RigidBody2D

@onready var pickup_area: Area2D = $PickupArea
@onready var pickup_collision: CollisionShape2D = $PickupArea/PickupCollision
@onready var item_shadow: AnimatedSprite2D = $ItemShadow
@onready var item_glow: AnimatedSprite2D = $ItemGlow
@onready var glow_animation: AnimationPlayer = $GlowAnimation
@onready var item_sprite: AnimatedSprite2D = $ItemSprite
@onready var item_animation: AnimationPlayer = $ItemAnimation

const sprite_frames = preload("res://Non_Entity/Items/Item.tres")
@export var custom_item_type: StringName
@export var custom_frame: int = 1

var is_carried := false
var possible_ingredients = ["raw_cut_liver", "raw_cut_pork", "egg", "noodles", "broth"]
var pot_array = []




func _ready() -> void:
	if custom_item_type: item_sprite.animation = custom_item_type
	if custom_frame: item_sprite.frame = custom_frame
	set_item(item_sprite.animation, item_sprite.frame)
	item_glow.play("unglow")
	#$FinishedBowl.region += Rect2(45, 0, 0, 0)

		
func _physics_process(delta: float) -> void:
	pass

func set_item(animation, frame) -> void:
	var item_shadow: AnimatedSprite2D = $ItemShadow
	var item_glow: AnimatedSprite2D = $ItemGlow
	var item_sprite: AnimatedSprite2D = $ItemSprite
	
	item_sprite.sprite_frames = sprite_frames
	item_sprite.animation = animation
	item_sprite.frame = frame
	
	item_glow.sprite_frames = item_sprite.sprite_frames
	item_glow.animation = item_sprite.animation
	item_glow.frame = frame - 1
	
	item_shadow.sprite_frames = item_sprite.sprite_frames
	item_shadow.animation = item_sprite.animation
	item_shadow.frame = item_sprite.frame


func glow() -> void:
	glow_animation.play("glow")
	glow_animation.queue("unglow")
func unglow() -> void:
	if glow_animation.animation_finished:
		glow_animation.play("unglow")	

func can_put_in_pot(item_type): 
	if (item_type in possible_ingredients) and (item_type not in pot_array):
		return true

func item_interact(item_carried) -> void:
	var item_type = item_carried.item_sprite.animation
	if can_put_in_pot(item_type) == true:
		pot_array.push_back(item_type)
		possible_ingredients.erase(item_type)
		
		item_carried.item_animation.play("into_pot")
		set_item("pot", 1)
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(item_carried, "global_position", global_position, .5)
		await get_tree().create_timer(.5).timeout
		item_carried.queue_free()
		
		print ("pot now contains: ", pot_array)
		
		if pot_array.size() > 0: set_item("pot", 3)

func hover() -> void:
	var hover := ["bowl","pot"]
	if item_sprite.animation in hover:
		#print(item_sprite.animation)
		pass


func pickup() -> void:
	item_animation.play("pickup")
	is_carried = true

func putdown() -> void:
	item_animation.play("putdown")
	is_carried = false

func dead() -> void:
	queue_free()
