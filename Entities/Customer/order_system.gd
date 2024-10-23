extends Node2D

# preload assets
var broth = {"Broth": preload("res://Entities/Customer/Order/broth.png")}
var noodles = {"NoodleType1": preload("res://Entities/Customer/Order/miki-noodles.png")}
var toppings = {
	"Topping1": preload("res://Entities/Customer/Order/pork.png"), 
	"Topping2": preload("res://Entities/Customer/Order/liver.png"), 
	"Topping3": preload("res://Entities/Customer/Order/chicharon.png")}
var background = {"Background": preload("res://Entities/Customer/Order/order-bg-4-ingre.png")}

# Nodes
var order_display 
@onready var hbox_container = get_node("Control/HBoxContainer")

func _ready():
	var order = stage1_order()
	display_order(order)

func stage1_order():
	var order = {}
	
	# Permi may broth
	order["Broth"] = broth["Broth"]
	
	# Only 1 noodle type
	order["Noodle"] = noodles["NoodleType1"]
	
	# Randomize toppings (at least 1, up to 3)
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 3 + 1  # between 1 and 3 toppings
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = toppings[topping_choice]
			chosen_toppings.append(topping_choice)
	
	return order

func display_order(order: Dictionary):
	# Clear previous order display
	var children = hbox_container.get_children()
	for child in children:
		child.queue_free()
	
	# Create a background sprite
	var background_sprite = TextureRect.new()
	background_sprite.texture = background["Background"]
	background_sprite.scale = Vector2(1, 1)  # No scaling needed if the texture is already 60x25
	hbox_container.add_child(background_sprite)

	# Set the position of the background sprite
	background.position = Vector2(0, 0)  # Position it at the top-left corner of the VBoxContainer

	# Display broth
	var broth_sprite = TextureRect.new()
	broth_sprite.texture = order["Broth"]
	broth_sprite.scale = Vector2(1, 1)  # Set size to match the asset
	broth_sprite.position = Vector2(5, 5)  # Centered in the background
	hbox_container.add_child(broth_sprite)
	
	# Display noodle
	var noodle_sprite = TextureRect.new()
	noodle_sprite.texture = order["Noodle"]
	noodle_sprite.scale = Vector2(1, 1)  # Set size to match the asset
	noodle_sprite.position = Vector2(16, 0)  # Adjusted position
	hbox_container.add_child(noodle_sprite)
	
	# Display toppings
	var topping_x = 32  # Starting x position for toppings
	var topping_count = 0  # Count the number of toppings

	for topping in order.keys():
		if topping.begins_with("Topping"):
			topping_count += 1  # Increment topping count

	# Adjust the starting position based on the number of toppings
	topping_x += (topping_count - 1) * 20  # Adjust for spacing if there are toppings

	for topping in order.keys():
		if topping.begins_with("Topping"):
			var topping_sprite = TextureRect.new()
			topping_sprite.texture = order[topping]
			topping_sprite.scale = Vector2(1, 1)  # Set size to match the asset
			topping_sprite.position = Vector2(topping_x, 5)  # Centered in the background
			hbox_container.add_child(topping_sprite)
			topping_x -= 20  # Decrement y position for next topping (16 for height + 4 for spacing)ng]
			hbox_container.add_child(topping_sprite)
