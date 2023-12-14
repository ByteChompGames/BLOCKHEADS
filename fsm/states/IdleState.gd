extends State
class_name IdleState

@export var actor : AIActor

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
	
	actor.set_animation_based_on_velocity()
	

func _on_timer_timeout():
	actor.set_wander_position()

func on_detect_enter_transition(_detected_body):
	actor.follow_target = _detected_body
	
	if actor.health < 30:
		Transitioned.emit(self, "flee")
	else:
		Transitioned.emit(self, "follow")
	
