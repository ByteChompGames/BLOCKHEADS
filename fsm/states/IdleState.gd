extends State
class_name IdleState

@export var actor : AIActor

@export var on_detect_transition_state : State

@onready var wait_timer = $WaitTimer

func enter():
	if actor == null:
		push_error("actor not assigned to Idle State, exiting state...")
		return
	
	wait_timer.start()

func exit():
	if not wait_timer.is_stopped():
		wait_timer.stop()

func physics_update(_delta : float):
	if actor.has_reached_destination():
		if wait_timer.is_stopped():
			actor.stop()
			wait_timer.start()
	else:
		actor.move(_delta)
	

func _on_timer_timeout():
	actor.set_wander_position()

func on_detect_enter_transition(_detected_body):
	print("here")
	actor.follow_target = _detected_body
	Transitioned.emit(self, on_detect_transition_state.name.to_lower())
