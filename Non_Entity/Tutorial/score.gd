extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set initial quota from Global
	set_quota(Global.get_quota())  # Initialize quota from Global
	
	# Update earnings based on the amount paid
	update_labels()  # Update labels to reflect initial values
	Global.connect("amount_paid_changed", Callable (self, "update_earnings"))
	
# Function to set the quota
func set_quota(new_quota: float):
	if Global.get_quota() != new_quota:  # Only update if there's a change
		Global.set_quota(new_quota)  # Use the setter function to update the Global quota
		update_labels()  # Update labels after changing quota

# Function to update earnings from Global
func update_earnings(total: float):
	total = Global.get_amount_paid()  # Retrieve the latest amount paid from Global
	print("Updated earnings from Global: ", total)  # Debugging output
	update_labels()

# Function to update the UI labels
func update_labels():
	$Quota.text = "Quota: PHP %.2f" % Global.get_quota()  # Display the Global quota
	$Earnings.text = "Earnings: PHP %.2f" % Global.get_amount_paid()  # Display the current earnings
	print("Updated Earnings Text: ", $Earnings.text)  # Debugging output
