extends PathFollow2D

var speed = 0.05
var stop_points = [0.50, 0.51, 0.52, 0.53]
var finish_point = 0.98
var current_stop_point_index = 3
var occupied_stop_points = []
var queue = []
var order_system

signal finished_path

func _ready():
	order_system = get_node("OrderSystem")

func _physics_process(delta):
	if current_stop_point_index >= 0:
		if progress_ratio < stop_points[current_stop_point_index]:
			progress_ratio = min(progress_ratio + delta * speed, stop_points[current_stop_point_index])
		else:
			# Stop moving when reaching the stop point
			progress_ratio = stop_points[current_stop_point_index]
			print("Reached stop point:", stop_points[current_stop_point_index])
			current_stop_point_index -= 1  # Move to the next stop point

			# Check if there are more stop points to process
			if current_stop_point_index < 0:
				current_stop_point_index = -1  # No more stop points
				print("Waiting for order...")
				emit_signal("finished_path")  # Signal that the path has been finished
	else:
		progress_ratio = min(progress_ratio + delta * speed, 0.49)

func occupy_stop_point():
	if occupied_stop_points.size() < stop_points.size():
		for i in range(stop_points.size()):
			if i not in occupied_stop_points:
				occupied_stop_points.append(i)
				current_stop_point_index = i
				progress_ratio = stop_points[i]
				print("Customer occupied stop point:", stop_points[i])
				return  # Exit after occupying a stop point
	else:
		# If all stop points are occupied, queue the customer at 0.49 - 0.01
		progress_ratio = 0.49 - 0.01
		queue.append(self)
		print("All stop points occupied, customer queued.")

func release_stop_point(index):
	if index in occupied_stop_points:
		occupied_stop_points.erase(index)
		print("Released stop point:", stop_points[index])
		if queue.size() > 0:
			var customer = queue.pop_front()
			customer.occupy_stop_point()  # Move the next customer from the queue to the released stop point

func move_to_next_stop_point():
	if current_stop_point_index < 0:
		current_stop_point_index = 0
	else:
		current_stop_point_index -= 1
	if current_stop_point_index < 0:
		current_stop_point_index = 0
		progress_ratio = 0.49
	else:
		progress_ratio = stop_points[current_stop_point_index]
