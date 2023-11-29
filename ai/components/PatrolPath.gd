extends Node2D
class_name PatrolPath

var current_point : int = -1
var points : int = 0

func _ready():
	points = get_child_count()

func get_next_point() -> Vector2:
	current_point += 1
	
	if current_point >= points:
		current_point = 0
	
	return get_child(current_point).global_position
	
