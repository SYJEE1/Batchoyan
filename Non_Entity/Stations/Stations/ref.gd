extends Area2D

const area_type := &"station"
var takes_item: bool = false
var tilemap_glow : TileMapLayer
const ITEM = preload("res://Non_Entity/Items/Item.tscn")


func _ready() -> void:
	tilemap_glow.modulate = Color(1,1,1,0)
	
func interact(carried_item) -> void:
	if carried_item == null:
		carried_item.item_sprite.frame = 1
		
func glow(carried_item) -> void:
	var glow_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	glow_tween.tween_property(tilemap_glow, "modulate", Color(1,1,1,1), .1)
	unglow(glow_tween)
	
func unglow(glow_tween) -> void:
	if glow_tween.finished: glow_tween.tween_property(tilemap_glow, "modulate", Color(1,1,1,0), .1)
