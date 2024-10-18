extends PathFollow2D

@export var speed: float = 0.1
@onready var customer_scene = preload("res://Entities/Customer/customer_scene.tscn")
var is_moving: bool = false

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
	get_parent().add_child(customer_instance)  # Correctly add the child to the parent
	
	# Update the position of the customer instance based on the PathFollow2D's position
	customer_instance.position = self.position  # Set position to PathFollow2D's position

	# Connect to the signal directly if the customer instance has a signal
	if customer_instance.has_method("connect"):
		customer_instance.connect("customer_finished", Callable(self, "_on_customer_finished"))

func _on_customer_finished():
	print("Customer has finished their path.")
