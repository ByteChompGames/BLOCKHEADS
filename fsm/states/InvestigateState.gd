extends State
class_name InvestigateState

@export var actor : AIActor

@export var on_target_found_transition : State
@export var on_time_out_transition : State

var follow_target : CharacterBody2D

@onready var search_timer = $SearchTimer

func enter():
	if actor == null:
		push_error("actor not assigned to Investigate State.")
	
	on_target_found_transition = actor.target_detect_state
	search_timer.start()
	actor.get_invesitgate_position()

func exit():
	if not search_timer.is_stopped():
		search_timer.stop()

func physics_update(_delta : float):
	if actor.has_reached_destination():
		actor.stop()
	else:
		actor.get_invesitgate_position()
		actor.move(_delta)

func on_detect_enter_transition(_detected_body):
	if _detected_body == actor.follow_target:
		Transitioned.emit(self, on_target_found_transition.name.to_lower())


func _on_search_timer_timeout():
	actor.follow_target = null
	Transitioned.emit(self, on_time_out_transition.name.to_lower())
