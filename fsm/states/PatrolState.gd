extends State
class_name PatrolState

@export var actor : AIActor

@export var lower_id_detect_transition : State
@export var higher_id_detect_transition : State

var left_point_not_reached = false

@onready var patrol_timer = $PatrolTimer

func _ready():
	patrol_timer.start()

func enter():
	if actor == null:
		push_error("Actor not assigned to Patrol State.")
	
	if left_point_not_reached:
		actor.resume_patrol()
		left_point_not_reached = false

func physics_update(_delta : float):
	if actor.has_reached_destination():
		actor.stop()
		if patrol_timer.is_stopped():
			patrol_timer.start()
	else:
		actor.move(_delta)
	
	actor.set_animation_based_on_velocity()

func exit():
	if not patrol_timer.is_stopped():
		patrol_timer.stop()

func on_detect_enter_transition(_detected_body):
	actor.follow_target = _detected_body
	
	if _detected_body.AI_ID > actor.AI_ID:
		Transitioned.emit(self, higher_id_detect_transition.name.to_lower())
		check_point_not_reached()
	if _detected_body.AI_ID < actor.AI_ID:
		Transitioned.emit(self, lower_id_detect_transition.name.to_lower())
		check_point_not_reached()

func check_point_not_reached():
	if actor.has_reached_destination():
		left_point_not_reached = false
	else:
		left_point_not_reached = true
		actor.pause_patrol()

func _on_patrol_timer_timeout():
	actor.set_next_patrol_position()
