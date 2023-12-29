extends State
class_name InvestigateState

@export var on_target_found_transition : State
@export var on_time_out_transition : State

var follow_target : CharacterBody2D

@onready var search_timer = $SearchTimer

func enter():
	if owner == null:
		push_error("owner not assigned to Investigate State.")
	
	on_target_found_transition = owner.target_detect_state
	if on_target_found_transition == FleeState:
		owner.last_known_direction *= -1
	search_timer.start()
	owner.get_invesitgate_position()

func exit():
	if not search_timer.is_stopped():
		search_timer.stop()

func physics_update(_delta : float):
	if owner.has_reached_destination():
		owner.stop()
	else:
		owner.get_invesitgate_position()
		owner.move(_delta)

func on_detect_enter_transition(_detected_body):
	if _detected_body == owner.follow_target:
		Transitioned.emit(self, on_target_found_transition.name.to_lower())


func _on_search_timer_timeout():
	owner.follow_target = null
	Transitioned.emit(self, on_time_out_transition.name.to_lower())
