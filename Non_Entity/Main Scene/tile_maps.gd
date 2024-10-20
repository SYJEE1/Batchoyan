extends Node2D

const INTERACT_AREA_SCENE = preload("res://Non_Entity/Stations/InteractArea.tscn")
@onready var countertop: TileMapLayer = $Countertop
@onready var broth: TileMapLayer = $Broth
@onready var trashbin: TileMapLayer = $Trashbin
@onready var cooler: TileMapLayer = $Cooler
@onready var cola_ref: TileMapLayer = $ColaRef
@onready var ref: TileMapLayer = $Ref
@onready var stove: TileMapLayer = $Stove
@onready var basket_pandesal: TileMapLayer = $BasketPandesal
@onready var basket_puto: TileMapLayer = $BasketPuto

# avoid these tiles based on atlas coordinates
var tiles_to_avoid = [Vector2i(13,4), Vector2i(19,17)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instantiate(countertop, preload("res://Non_Entity/Stations/Stations/countertop.gd"))
	instantiate(broth, preload("res://Non_Entity/Stations/Stations/broth.gd"))
	instantiate(trashbin, preload("res://Non_Entity/Stations/Stations/trashbin.gd"))
	instantiate(cooler, preload("res://Non_Entity/Stations/Stations/cooler.gd"))
	instantiate(cola_ref, preload("res://Non_Entity/Stations/Stations/colaref.gd"))
	#instantiate(ref, preload("res://Non_Entity/Stations/Stations/ref.gd"))
	#instantiate(stove, preload("res://Non_Entity/Stations/Stations/stove.gd"))
	#instantiate(basket_pandesal, preload("res://Non_Entity/Stations/Stations/basketpandesal.gd"))
	#instantiate(basket_puto, preload("res://Non_Entity/Stations/Stations/basketputo.gd"))
	
func instantiate(tilemaplayer: TileMapLayer, script) -> void:
	for each_coords in tilemaplayer.get_used_cells(): # for every tile,
		
		
		
		if tilemaplayer.get_cell_atlas_coords(each_coords) in tiles_to_avoid:
			tiles_to_avoid.pop_front()
			#pass
			
		else:
			# instantiate interact collision scene
			var instance = INTERACT_AREA_SCENE.instantiate()
			instance.global_position = tilemaplayer.map_to_local(each_coords) #+ Vector2(0,y_offset)
			
			# add the preloaded scripts & assign their glow layer
			instance.set_script(script)
			instance.tilemap_glow = tilemaplayer.get_child(0)
			
			# add the instantiated collision + their scripts to each station
			tilemaplayer.add_child(instance)
