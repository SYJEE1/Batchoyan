extends RigidBody2D

var is_carried : bool = false

@onready var pickup_area: Area2D = $PickupArea
@onready var pickup_collision: CollisionShape2D = $PickupArea/PickupCollision
@onready var item_sprite: AnimatedSprite2D = $ItemSprite 
@onready var item_shadow: AnimatedSprite2D = $ItemShadow
@onready var item_animation: AnimationPlayer = $ItemAnimation
@onready var glow_animation: AnimationPlayer = $ItemGlow/GlowAnimation


func _ready() -> void:
	glow_animation.play("unglow")
	item_shadow.sprite_frames = item_sprite.sprite_frames
	item_shadow.animation = item_sprite.animation

	if self.get_parent().has_method("interact") == null:
		pickup_collision.disabled = true
		is_carried = true
	else: 
		pickup_collision.disabled = false
		is_carried = false
		
func _physics_process(delta: float) -> void:
	pass


func glow() -> void:
	glow_animation.play("glow")
	glow_animation.queue("unglow")
	
func pickup() -> void:
	item_animation.play("pickup")
	is_carried = true

func putdown() -> void:
	item_animation.play("putdown")
	is_carried = false
