extends PathFollow2D

@export var speed: float = 0.1
@onready var customer_scene = preload("res://Entities/Customer/customer_scene.tscn")
var is_moving: bool = false
var order_counter: int = 0  # Counter to keep track of orders

signal customer_finished

func _ready():
	is_moving = true
	spawn_customer()

func _process(delta):
	if is_moving:
		# Ensure the parent has a valid path curve
		var path_curve = get_parent().get_curve()
		if path_curve:
			progress_ratio += speed * delta
			if progress_ratio >= path_curve.get_baked_length():
				progress_ratio = path_curve.get_baked_length()
				is_moving = false
				emit_signal("customer_finished", self)  # Emit signal when finished

func spawn_customer():
	var customer_instance = customer_scene.instantiate()
	print("Customer instance created: ", customer_instance)  # Debugging line
	
	# Set the order for the customer
	order_counter += 1
	customer_instance.set("order", order_counter)  # Assuming 'order' is a property in the customer scene
	print("Customer order: ", customer_instance.get("order"))  # Print the customer's order for debugging
	
	# Add the customer instance as a child of the PathFollow2D
	add_child(customer_instance)  
	
	# Position the customer instance relative to the PathFollow2D
	customer_instance.position = Vector2.ZERO  # Set position to (0, 0) relative to the PathFollow2D
	customer_instance.z_index = 1
	
	# Connect to the signal directly if the customer instance has a signal
	if customer_instance.has_method("connect"):
		customer_instance.connect("customer_finished", Callable(self, "_on_customer_finished"))
	
func _on_customer_finished():
	print("Customer has finished their path.")
