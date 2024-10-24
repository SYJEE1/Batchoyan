extends RigidBody2D

@onready var pickup_area: Area2D = $PickupArea
@onready var pickup_collision: CollisionShape2D = $PickupArea/PickupCollision
@onready var item_shadow: AnimatedSprite2D = $ItemShadow
@onready var item_glow: AnimatedSprite2D = $ItemGlow

@onready var glow_animation: AnimationPlayer = $GlowAnimation
@onready var item_sprite: AnimatedSprite2D = $ItemSprite
@onready var item_animation: AnimationPlayer = $ItemAnimation
@onready var effects: Sprite2D = $ItemSprite/Effects
@onready var progress_bar: TextureProgressBar = $ItemSprite/ProgressBar
@onready var cook_timer: Timer = $ItemSprite/InsidePot/CookTimer
@onready var inside_pot: Sprite2D = $ItemSprite/InsidePot

@onready var effects_animation: AnimationPlayer = $ItemSprite/EffectsAnimation
@onready var fire: Sprite2D = $ItemSprite/Fire


const sprite_frames = preload("res://Non_Entity/Items/Item.tres")
@export var custom_item_type: StringName
@export var custom_frame: int = 1

var is_carried := false
var possible_ingredients = ["raw_cut_liver", "raw_cut_pork", "egg", "noodles", "broth"]
var pot_array = []
var on_stove := false

#func _physics_process(delta: float) -> void:
	#print(possible_ingredients)


func _ready() -> void:
	if custom_item_type: item_sprite.animation = custom_item_type
	if custom_frame: item_sprite.frame = custom_frame
	set_item(item_sprite.animation, item_sprite.frame)
	
	progress_bar.value = 0 
	item_glow.play("unglow")
	fire.get_child(0).play("RESET")
	effects_animation.play("insidepot_exit")
	$ItemSprite/InsidePot.visible = true
	on_stove = false
	update_pot()
	



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


func glow(time:int = 2) -> void:
	glow_animation.play("glow")
	if item_sprite.animation == "pot" and pot_array.size() > 0:
		effects_animation.play("insidepot_enter")
		await get_tree().create_timer(time).timeout
		effects_animation.queue("insidepot_exit")
	
	glow_animation.queue("unglow")
	
func unglow() -> void:
	if glow_animation.animation_finished:
		glow_animation.play("unglow")	

func can_put_in_pot(item_type): 
	
	if (item_type in possible_ingredients) and (item_type not in pot_array): 
		return true

func item_interact(item_carried) -> void:
	var item_type = item_carried.item_sprite.animation
	var noodle_type: String
	
	if item_type in ["miswa","bihon","sotanghon","miki"]: 
		noodle_type = item_type
		item_type = "noodles"
			
	if can_put_in_pot(item_type) == true:
		if item_type == "noodles":
			$ItemSprite/InsidePot/Noodle.animation = noodle_type
			$ItemSprite/InsidePot/Noodle.frame = 1
		print("putting in pot: ", item_type)
		pot_array.push_back(item_type)
		possible_ingredients.erase(item_type)
		
		# animation
		item_carried.item_animation.play("into_pot")
		set_item("pot", 1)
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(item_carried, "global_position", global_position, .5)
		await get_tree().create_timer(.5).timeout
		item_carried.queue_free()
		
		if progress_bar.value < progress_bar.max_value:
			progress_bar.max_value = 10 * pot_array.size()
		
		update_pot()
		
func holdingpot_interact(item_type) -> void:
	if can_put_in_pot(item_type) == true:
		pot_array.push_back(item_type)
		possible_ingredients.erase(item_type)
		glow(3)
		if pot_array.size() > 0: set_item("pot", 3)
		
		update_pot()
		
func toggle_onstove():
	on_stove = !on_stove
	await get_tree().create_timer(.5).timeout
	update_pot()

func update_pot() -> void:
		
	# on stove, fire animation
	if on_stove == true and pot_array.size() > 0:
		progress_bar.visible = true
		fire.get_child(0).play("fire")
		fire.get_child(1).emitting = true
	else: 
		fire.get_child(0).play("nofire")
		fire.get_child(1).emitting = false
	
	# Cook Timer runs when on stove
	if on_stove == true and pot_array.size() > 0: 
		cook_timer.paused = false
	else: cook_timer.paused = true
	
	
	
	# Reset Pot Values
	print ("pot now contains: ", pot_array)
	$ItemSprite/InsidePot/Liver.visible = false
	$ItemSprite/InsidePot/Pork.visible = false
	$ItemSprite/InsidePot/Egg.visible = false
	$ItemSprite/InsidePot/Noodle.visible = false
	$ItemSprite/InsidePot.texture.region = Rect2(192,176,48,32)
	
	# Checks if pot has an item and puts a lid
	if pot_array.size() > 0:
		set_item("pot", 3)
	else: possible_ingredients = ["raw_cut_liver", "raw_cut_pork", "egg", "noodles", "broth"]
		
	# item goes into pot
	for item_type in pot_array:
		if item_type == "broth": $ItemSprite/InsidePot.texture.region = Rect2(240,176,48,32)
		if item_type == "raw_cut_liver": $ItemSprite/InsidePot/Liver.visible = true
		if item_type == "raw_cut_pork": $ItemSprite/InsidePot/Pork.visible = true
		if item_type == "egg": $ItemSprite/InsidePot/Egg.visible = true
		if item_type in ["miswa","bihon","sotanghon","miki"]: $ItemSprite/InsidePot/Noodle.visible = true
	

	
	
	
func pickup() -> void:
	on_stove = false
	update_pot()
	item_animation.play("pickup")
	is_carried = true
	sleeping = false

func putdown() -> void:
	item_animation.play("putdown")
	is_carried = false
	sleeping = true

func dead() -> void:
	queue_free()

func reset() -> void:
	print("resetting")
	_ready()
	print(possible_ingredients)
	progress_bar.value = 0
	progress_bar.visible = false
	set_item("pot", 1)
	pot_array.clear()
	$ItemSprite/Fire/Overcooked.emitting = false
	$ItemSprite/Fire/Burnt.emitting = false
	update_pot()
		


func _on_cook_timer_timeout() -> void:
	progress_bar.value += 1
	if progress_bar.value < progress_bar.max_value * 1.00: progress_bar.tint_progress = Color.LIGHT_GRAY
	elif progress_bar.value <= progress_bar.max_value * 1.20: progress_bar.tint_progress = Color.GREEN
	elif progress_bar.value <= progress_bar.max_value * 1.40: progress_bar.tint_progress = Color.YELLOW
	elif progress_bar.value <= progress_bar.max_value * 1.60: progress_bar.tint_progress = Color.ORANGE
	elif progress_bar.value <= progress_bar.max_value * 1.80: progress_bar.tint_progress = Color.RED
	elif progress_bar.value >= progress_bar.max_value * 2.20: 
		on_stove = false
		$ItemSprite/Fire/Overcooked.emitting = true
		$ItemSprite/Fire/Burnt.emitting = true
		progress_bar.tint_progress = Color.BLACK
		update_pot()
	
	
	
	
	
	
	
	
	
