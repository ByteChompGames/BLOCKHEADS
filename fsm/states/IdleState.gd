extends State
class_name IdleState

@onready var wait_timer = $WaitTimer

func enter():
	wait_timer.start()
	
	if owner.is_node_ready():
		if owner.health.health_condition != Health.Condition.FULL:
			owner.health.start_healing()

func exit():
	if not wait_timer.is_stopped():
		wait_timer.stop()
	
	owner.health.stop_healing()

func physics_update(_delta : float):
	if owner.has_reached_destination():
		if wait_timer.is_stopped():
			owner.stop()
			wait_timer.start()
	else:
		owner.move(_delta)
	
	owner.set_animation_based_on_velocity()
	

func _on_timer_timeout():
	owner.set_wander_position()

func on_detect_enter_transition(_detected_body):
	owner.follow_target = _detected_body
	
	if owner.health.health_condition == Health.Condition.CRITICAL:
		Transitioned.emit(self, "flee")
	else:
		Transitioned.emit(self, "follow")
	
