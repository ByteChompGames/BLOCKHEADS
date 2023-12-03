extends State
class_name RunState

@export var actor : AIActor

@export var repath_range: Vector2 = Vector2(1, 3)

@onready var repath_timer = $RepathTimer

func enter():
	if actor == null:
		push_error("actor not assigned to Idle State, exiting state...")
		return
	
	repath_timer.wait_time = randf_range(repath_range.x, repath_range.y)
	repath_timer.start()

func exit():
	if not repath_timer.is_stopped():
		repath_timer.stop()

func physics_update(_delta : float):
	if actor.has_reached_destination():
			actor.stop()
	else:
		actor.move(_delta)

func _on_repath_timer_timeout():
	repath_timer.wait_time = randf_range(repath_range.x, repath_range.y)
	actor.set_run_position()
