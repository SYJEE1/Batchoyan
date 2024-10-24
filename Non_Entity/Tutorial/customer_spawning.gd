extends Node2D

@onready var customer_scene: PackedScene = preload("res://Entities/Customer/customer_scene.tscn")
@onready var spawn_point_1 = get_node("A")
@onready var spawn_point_2 = get_node("B")
@onready var spawn_point_3 = get_node("C")
@export var min_spawn_interval: float = 3.0
@export var max_spawn_interval: float = 5.0

var total_customers_spawned: int = 0
var timer: Timer = null
var spawn_points: Array = []
var occupied_points: Dictionary = {}  # Dictionary to keep track of occupied points
var audio_stream_player: AudioStreamPlayer
var spawn_sound: AudioStream
var spawn_volume_db: float = -25.0

func _ready():
	spawn_sound = preload("res://Entities/Customer/Store Door Sound Effect.mp3")
	audio_stream_player = AudioStreamPlayer.new()  
	audio_stream_player.stream = spawn_sound
	audio_stream_player.volume_db = spawn_volume_db
	add_child(audio_stream_player)
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", Callable(self, "spawn_customer"))
	randomize()
	spawn_points = [spawn_point_1, spawn_point_2, spawn_point_3]
	for point in spawn_points:
		occupied_points[point] = false  # Initialize all points as unoccupied
	timer.start(randf_range(min_spawn_interval, max_spawn_interval))
	Global.connect("max_customers", Callable (self, "spawn_customer"))

func spawn_customer():
	var max_total_customers = Global.send_max_customers()
	if total_customers_spawned >= max_total_customers:
		return
	
	var available_points = get_available_spawn_points()
	if available_points.size() > 0:
		var point = available_points[randi() % available_points.size()]  # Randomly select an available point
		var customer = customer_scene.instantiate() 
		var animation_player = customer.get_node("Customer/AnimationPlayer")  
		var animations = ["1", "2", "3", "4"]
		var random_animation = animations[randi() % animations.size()]  # Randomly select an animation
		add_customer_to_point(customer, point)
		animation_player.play(random_animation)
		animation_player.get_animation(random_animation).loop = true  
		audio_stream_player.play()
		occupied_points[point] = true  # Mark the point as occupied
		total_customers_spawned += 1  # Increment total customers spawned
		Global.get_total_customers(total_customers_spawned)
		# Global.checking_condition()

	timer.start(randf_range(min_spawn_interval, max_spawn_interval))

func add_customer_to_point(customer: Node2D, point: Node2D):
	customer.position = point.position  # Set the customer's position to the spawn point
	get_tree().current_scene.add_child(customer)  # Add the customer as a child of the scene
	customer.spawn_point = point
	customer.connect("removed", Callable(self, "_on_customer_removed"))  # Connect the removal signal

func get_available_spawn_points() -> Array:
	var available_points = []
	for point in spawn_points:
		if !occupied_points[point]:  # Check if the point is available
			available_points.append(point)  # Add to the list of available points
	return available_points  # Return the list of available points

func _on_customer_removed(customer: Node2D):
	if customer.spawn_point:  # Check if the spawn point is set
		occupied_points[customer.spawn_point] = false  # Mark the customer's spawn point as unoccupied
		
