extends Node2D

@onready var customer_scene: PackedScene = preload("res://Entities/Customer/customer_scene.tscn")
@onready var spawn_point_1 = get_node("A")
@onready var spawn_point_2 = get_node("B")
@onready var spawn_point_3 = get_node("C")
@export var min_spawn_interval: float = 1.0
@export var max_spawn_interval: float = 2.0

var max_total_customers: int = 5
var total_customers_spawned: int = 0
var timer: Timer = null
var spawn_points: Array = []
var occupied_points: Dictionary = {}  # Dictionary to keep track of occupied points

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", Callable(self, "spawn_customer"))
	randomize()
	spawn_points = [spawn_point_1, spawn_point_2, spawn_point_3]
	for point in spawn_points:
		occupied_points[point] = false  # Initialize all points as unoccupied
	timer.start(randf_range(min_spawn_interval, max_spawn_interval))

func spawn_customer():
	print("Attempting to spawn customer. Total customers spawned: ", total_customers_spawned)

	if total_customers_spawned >= max_total_customers:
		print("Maximum customers reached. Not spawning.")
		return
	
	var available_points = get_available_spawn_points()
	if available_points.size() > 0:
		var point = available_points[randi() % available_points.size()]  # Randomly select an available point
		var customer = customer_scene.instantiate()  # Create a new customer
		add_customer_to_point(customer, point)  # Add the customer to the selected point
		occupied_points[point] = true  # Mark the point as occupied
		total_customers_spawned += 1  # Increment total customers spawned
		print("Customer spawned at ", point.name, ". New total: ", total_customers_spawned)
		print("Adding customer to point: ", point.name)
	else:
		print("No available spawn points.")

	timer.start(randf_range(min_spawn_interval, max_spawn_interval))

func add_customer_to_point(customer: Node2D, point: Node2D):
	customer.position = point.position  # Set the customer's position to the spawn point
	get_tree().current_scene.add_child(customer)  # Add the customer as a child of the scene
	customer.spawn_point = point
	customer.connect("removed", Callable(self, "_on_customer_removed"))  # Connect the removal signal
	print("Connected removed signal for customer at point: ", point.name)

func get_available_spawn_points() -> Array:
	var available_points = []
	for point in spawn_points:
		if !occupied_points[point]:  # Check if the point is available
			available_points.append(point)  # Add to the list of available points
	return available_points  # Return the list of available points

func _on_customer_removed(customer: Node2D):
	if customer.spawn_point:  # Check if the spawn point is set
		occupied_points[customer.spawn_point] = false  # Mark the customer's spawn point as unoccupied
		print("Point ", customer.spawn_point.name, " is now unoccupied.")
	print("Customer type: ", customer.get_class())
	print("Customer removed. New total: ", total_customers_spawned)
