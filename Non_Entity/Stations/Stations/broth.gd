extends Area2D

const area_type := "station"
var takes_item: bool = true
var tilemap_glow : TileMapLayer
@onready var interact_collision: CollisionShape2D = $InteractCollision


func _ready() -> void:
	position += Vector2(0,3)
	interact_collision.shape.size = Vector2(16,8)
	tilemap_glow.modulate = Color(1,1,1,0)
	

func interact(carried_item) -> void:
	var item = carried_item.item_sprite
	if item.animation == "bowl_regular" and item.frame == 1: item.frame = 2
	if item.animation == "bowl_super" and item.frame == 1: item.frame = 2
	Global.current_item_animation = item.animation
	Global.current_item_frame = item.frame
		
func glow(carried_item) -> void:

	var item = carried_item.item_sprite
	if (item.animation == "bowl_regular" or item.animation == "bowl_super") and item.frame == 1:
		var glow_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		glow_tween.tween_property(tilemap_glow, "modulate", Color(1,1,1,1), .1)
		unglow(glow_tween)
	
func unglow(glow_tween) -> void:
	if glow_tween.finished:
		glow_tween.tween_property(tilemap_glow, "modulate", Color(1,1,1,0), .1)
