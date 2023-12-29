extends State
class_name RunState

@export var repath_range: Vector2 = Vector2(1, 3)

@onready var repath_timer = $RepathTimer

func enter():
	if owner == null:
		push_error("owner not assigned to Idle State, exiting state...")
		return
	
	repath_timer.wait_time = randf_range(repath_range.x, repath_range.y)
	repath_timer.start()

func exit():
	if not repath_timer.is_stopped():
		repath_timer.stop()

func physics_update(_delta : float):
	if owner.has_reached_destination():
			owner.stop()
	else:
		owner.move(_delta)
	
	owner.set_animation_based_on_velocity()

func _on_repath_timer_timeout():
	repath_timer.wait_time = randf_range(repath_range.x, repath_range.y)
	owner.set_run_position()
