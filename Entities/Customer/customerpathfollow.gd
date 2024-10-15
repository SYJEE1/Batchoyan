extends PathFollow2D

var speed = 0.05
var stop_points = [0.50, 0.51, 0.52, 0.53]
var finish_point = 0.98
var has_placed_order = false
var is_order_placed_manually = false
var current_stop_point_index = 3
var occupied_stop_points = []
var queue = []

signal finished_path

func _physics_process(delta):
	if not has_placed_order:
		if not is_order_placed_manually:
			if current_stop_point_index >= 0:
				if progress_ratio < stop_points[current_stop_point_index]:
					progress_ratio = min(progress_ratio + delta * speed, stop_points[current_stop_point_index])
				else:
					current_stop_point_index -= 1
			else:
				progress_ratio = min(progress_ratio + delta * speed, 0.49)
		if progress_ratio >= stop_points[current_stop_point_index] if current_stop_point_index >= 0 else progress_ratio >= 0.49:
			print("Waiting for order...")
	else:
		progress_ratio = min(progress_ratio + delta * speed, finish_point)
		if progress_ratio >= finish_point:
			print("Order received, clearing queue")
			emit_signal("finished_path")

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

func _on_PathFollow2D_finished_path():
	release_stop_point(current_stop_point_index)
