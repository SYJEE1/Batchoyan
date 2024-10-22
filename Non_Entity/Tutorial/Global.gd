# In Global.gd
extends Node

var amount_paid: float = 0.0
var total_earnings: float = 0.0
var quota: float = 1000.0

signal amount_paid_changed(new_amount: float)

func get_quota() -> float:
	return quota

func set_amount_paid(new_amount_paid: float):
	amount_paid += new_amount_paid
	emit_signal("amount_paid_changed", amount_paid)  # Notify listeners
	print("amount paid signal")

func get_amount_paid() -> float:
	return amount_paid
