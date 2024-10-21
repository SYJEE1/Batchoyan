extends Control

var quota: float = 1000.0
var earnings: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	update_labels()

# Function to update the labels with current quota and earnings
func update_labels():
	$Quota.text = "Quota: " + str(quota)
	$Earnings.text = "Earnings: PHP" + str(earnings)

# Function to set the quota
func set_quota(new_quota: float):
	quota = new_quota
	update_labels()

# Function to add to earnings
func add_earnings(amount_paid: float):
	print("Adding earnings: ", amount_paid)  # Debug print
	earnings += amount_paid  # This should accumulate the earnings
	print("New earnings: ", earnings)  # Debug print
	update_labels()  # Update the labels to reflect the new total
