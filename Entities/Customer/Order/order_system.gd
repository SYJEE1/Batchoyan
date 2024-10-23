extends Node2D

# Preload assets with their prices
var bowl = {
	"Bowl1": {"texture": preload("res://Entities/Customer/Order/ingredients/bowl-regular.png"), "price": 30},
	"Bowl2": {"texture": preload("res://Entities/Customer/Order/ingredients/bowl-super.png"), "price": 50}
}

var noodles = {
	"NoodleType1": {"texture": preload("res://Entities/Customer/Order/ingredients/miki.png"), "price": 20},
	"NoodleType2": {"texture": preload("res://Entities/Customer/Order/ingredients/miswa.png"), "price": 20},
	"NoodleType3": {"texture": preload("res://Entities/Customer/Order/ingredients/sotanghon.png"), "price": 20},
	"NoodleType4": {"texture": preload("res://Entities/Customer/Order/ingredients/bihon.png"), "price": 20}
}

var toppings = {
	"Topping1": {"texture": preload("res://Entities/Customer/Order/ingredients/pork.png"), "price": 10},
	"Topping2": {"texture": preload("res://Entities/Customer/Order/ingredients/liver.png"), "price": 10},
	"Topping3": {"texture": preload("res://Entities/Customer/Order/ingredients/chicharon-temp.png"), "price": 10},
	"Topping4": {"texture": preload("res://Entities/Customer/Order/ingredients/egg.png"), "price": 10}
}

var drinks = {
	"Drink1": {"texture": preload("res://Entities/Customer/Order/ingredients/water.png"), "price": 10},
	"Drink2": {"texture": preload("res://Entities/Customer/Order/ingredients/cora.png"), "price": 15},
	"Drink3": {"texture": preload("res://Entities/Customer/Order/ingredients/sprike.png"), "price": 20},
	"Drink4": {"texture": preload("res://Entities/Customer/Order/ingredients/loyal.png"), "price": 20},
	"Drink5": {"texture": preload("res://Entities/Customer/Order/ingredients/c3.png"), "price": 20}
}

var sidedish = {
	"Sidedish1": {"texture": preload("res://Entities/Customer/Order/ingredients/puto.png"), "price": 20},
	"Sidedish2": {"texture": preload("res://Entities/Customer/Order/ingredients/pandesal.png"), "price": 20}
}
# Nodes
@onready var vbox_container= get_node("Control/VBoxContainer")

func _ready():
	var order = tutorial()
	print(order)
	var total_price = calculate_total_price(order)
	print("Total Price: ", total_price)
	display_order(order)  # Call display_order to visualize the order

func tutorial() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[0]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[0]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	for topping_choice in topping_keys:
		order[topping_choice] = topping_choice
		chosen_toppings.append(topping_choice)

	return order
func stage1_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[0]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[0]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	return order
func stage2_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[0]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[0]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[0]  # Store the key

	return order
func stage3_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[0]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[randi() % 2]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[0]  # Store the key

	return order
func stage4_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[randi() % bowl_keys.size()]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[randi() % 2]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[0]  # Store the key

	return order
func stage5_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[randi() % bowl_keys.size()]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[randi() % 3]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[0]  # Store the key

	return order
func stage6_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[randi() % bowl_keys.size()]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[randi() % 3]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[randi() % drink_keys.size()]  # Store the key

	return order
func stage7_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[randi() % bowl_keys.size()]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[randi() % 3]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[randi() % drink_keys.size()]  # Store the key
	
	var sidedish_keys = sidedish.keys()
	order["Sidedish"] = sidedish_keys[0]

	return order
func stage8_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[randi() % bowl_keys.size()]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[randi() % noodle_keys.size()]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[randi() % drink_keys.size()]  # Store the key
	
	var sidedish_keys = sidedish.keys()
	order["Sidedish"] = sidedish_keys[0]

	return order
func stage9_order() -> Dictionary:
	var order = {}
	
	# Populate the bowl
	var bowl_keys = bowl.keys()
	order["Bowl"] = bowl_keys[randi() % bowl_keys.size()]  # Store the key

	# Populate the noodle
	var noodle_keys = noodles.keys()
	order["Noodle"] = noodle_keys[randi() % noodle_keys.size()]  # Store the key

	# Populate toppings
	var topping_keys = toppings.keys()
	var chosen_toppings = []
	var num_toppings = randi() % 4 + 1 
	for i in range(num_toppings):
		var topping_choice = topping_keys[randi() % topping_keys.size()]
		if topping_choice not in chosen_toppings:
			order[topping_choice] = topping_choice  # Store the key
			chosen_toppings.append(topping_choice)

	# Populate drinks
	var drink_keys = drinks.keys()
	order["Drink"] = drink_keys[randi() % drink_keys.size()]  # Store the key
	
	var sidedish_keys = sidedish.keys()
	order["Sidedish"] = sidedish_keys[randi() % sidedish_keys.size()]

	return order

func display_order(order: Dictionary):
	# Clear previous order display
	var children = vbox_container.get_children()
	for child in children:
		child.queue_free()
	
	# Initialize the first HBoxContainer
	var hbox_container = HBoxContainer.new()
	vbox_container.add_child(hbox_container)
	var sprite_count = 0
	
	# Display bowl
	if order.has("Bowl"):
		var bowl_key = order["Bowl"]
		var bowl_sprite = TextureRect.new()
		bowl_sprite.texture = bowl[bowl_key]["texture"]  # Access the texture
		bowl_sprite.scale = Vector2(1, 1)  # Set size to match the asset
		bowl_sprite.position = Vector2(5, 5)  # Position for bowl
		hbox_container.add_child(bowl_sprite)
		sprite_count += 1  # Increment sprite count

	# Display noodle
	if order.has("Noodle"):
		var noodle_key = order["Noodle"]
		var noodle_sprite = TextureRect.new()
		noodle_sprite.texture = noodles[noodle_key]["texture"]  # Access the texture
		noodle_sprite.scale = Vector2(1, 1)  # Set size to match the asset
		noodle_sprite.position = Vector2(16, 0)  # Position for noodle
		hbox_container.add_child(noodle_sprite)
		sprite_count += 1  # Increment sprite count

	# Display toppings
	var topping_x = 32  # Starting x position for toppings
	var topping_count = 0  # Count the number of toppings

	# Count toppings
	for topping in order.keys():
		if topping.begins_with("Topping"):
			topping_count += 1  # Increment topping count

	# Adjust the starting position based on the number of toppings
	topping_x += (topping_count - 1) * 16  # Adjust for spacing if there are toppings

	# Display each topping
	for topping in order.keys():
		if topping.begins_with("Topping"):
			var topping_sprite = TextureRect.new()
			topping_sprite.texture = toppings[topping]["texture"]  # Access the texture
			topping_sprite.scale = Vector2(1, 1)  # Set size to match the asset
			topping_sprite.position = Vector2(topping_x, 5)  # Centered in the background
			if sprite_count < 6:
				hbox_container.add_child(topping_sprite)
				sprite_count += 1  # Increment sprite count
			else:
				# Create a new HBoxContainer for the next row
				hbox_container = HBoxContainer.new()
				vbox_container.add_child(hbox_container)
				hbox_container.add_child(topping_sprite)
				sprite_count = 1  # Reset sprite count
			topping_x -= 20  # Decrement x position for next topping (20 for spacing)

	# Display drink
	if order.has("Drink"):
		var drink_key = order["Drink"]
		var drink_sprite = TextureRect.new()
		drink_sprite.texture = drinks[drink_key]["texture"]  # Access the texture
		drink_sprite.scale = Vector2(1, 1)  # Set size to match the asset
		drink_sprite.position = Vector2(5, 40)  # Position for drink
		if sprite_count < 6:
			hbox_container.add_child(drink_sprite)
			sprite_count += 1  # Increment sprite count
		else:
			# Create a new HBoxContainer for the next row
			hbox_container = HBoxContainer.new()
			vbox_container.add_child(hbox_container)
			hbox_container.add_child(drink_sprite)
			sprite_count = 1  # Reset sprite count

	if order.has("Sidedish"):
		var sidedish_key = order["Sidedish"]
		var sidedish_sprite = TextureRect.new()
		sidedish_sprite.texture = sidedish[sidedish_key]["texture"]  # Access the texture
		sidedish_sprite.scale = Vector2(1, 1)  # Set size to match the asset
		sidedish_sprite.position = Vector2(5, 40)  # Position for drink
		if sprite_count < 6:
			hbox_container.add_child(sidedish_sprite)
			sprite_count += 1  # Increment sprite count
		else:
			# Create a new HBoxContainer for the next row
			hbox_container = HBoxContainer.new()
			vbox_container.add_child(hbox_container)
			hbox_container.add_child(sidedish_sprite)
			sprite_count = 1  # Reset sprite count

func calculate_total_price(order: Dictionary) -> float:
	var total: float = 0.0
	
	# Calculate the total price based on the order
	if order.has("Bowl"):
		var bowl_key = order["Bowl"]
		total += bowl[bowl_key]["price"]  # Access the price

	if order.has("Noodle"):
		var noodle_key = order["Noodle"]
		total += noodles[noodle_key]["price"]  # Access the price

	# Calculate total for toppings
	for topping in order.keys():
		if topping.begins_with("Topping"):
			total += toppings[topping]["price"]  # Access the price

	if order.has("Drink"):
		var drink_key = order["Drink"]
		total += drinks[drink_key]["price"]  # Access the price
		
	if order.has("Sidedish"):
		var sidedish_key = order["Sidedish"]
		total += sidedish[sidedish_key]["price"]  # Access the price

	return total
