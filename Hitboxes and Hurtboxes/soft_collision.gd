extends Area2D

func is_colliding():
	return has_overlapping_areas()
	
func get_push_vector():
	var push_vector = Vector2.ZERO
	if has_overlapping_areas():
		var area = get_overlapping_areas()[0]
		push_vector = area.global_position.direction_to(global_position).normalized()
	return push_vector
