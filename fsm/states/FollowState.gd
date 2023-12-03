extends State
class_name FollowState

@export var actor : AIActor

@export var on_detect_lost_transition_state : State

var follow_target : CharacterBody2D

@onready var pathing_timer = $PathingTimer

func enter():
	if actor == null:
		push_error("actor not assigned to Follow State, exiting state...")
	
	if actor.follow_target:
		follow_target = actor.follow_target
		pathing_timer.start()
	else:
		push_error("actor has no target to follow, exiting Follow State...")

func exit():
	if not pathing_timer.is_stopped():
		pathing_timer.stop()

func physics_update(_delta : float):
	if actor.has_reached_destination():
		actor.stop()
	else:
		actor.set_follow_speed()
		actor.move(_delta)

func on_detect_exit_transition(_detected_body):
	actor.target_detect_state = self
	actor.set_last_known_direction(_detected_body.global_position)
	Transitioned.emit(self, on_detect_lost_transition_state.name.to_lower())

func _on_pathing_timer_timeout():
	actor.set_follow_position()
