extends State
class_name PatrolState

var left_point_not_reached = false

@onready var patrol_timer = $PatrolTimer

func _ready():
	patrol_timer.start()

func enter():
	if owner == null:
		push_error("Actor not assigned to Patrol State.")
	
	if left_point_not_reached:
		owner.resume_patrol()
		left_point_not_reached = false
	
	if owner.is_node_ready():
		if owner.health.health_condition != Health.Condition.FULL:
			owner.health.start_healing()

func physics_update(_delta : float):
	if owner.has_reached_destination():
		owner.stop()
		if patrol_timer.is_stopped():
			patrol_timer.start()
	else:
		owner.move(_delta)
	
	owner.set_animation_based_on_velocity()

func exit():
	if not patrol_timer.is_stopped():
		patrol_timer.stop()
	
		owner.health.stop_healing()

func on_detect_enter_transition(_detected_body):
	owner.follow_target = _detected_body
	
	if owner.health.health_condition == Health.Condition.CRITICAL:
		Transitioned.emit(self, "flee")
		check_point_not_reached()
	else:
		Transitioned.emit(self, "follow")
		check_point_not_reached()

func check_point_not_reached():
	if owner.has_reached_destination():
		left_point_not_reached = false
	else:
		left_point_not_reached = true
		owner.pause_patrol()

func _on_patrol_timer_timeout():
	owner.set_next_patrol_position()
