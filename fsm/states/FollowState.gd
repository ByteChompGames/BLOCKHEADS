extends State
class_name FollowState

@export var actor : AIActor

@export var on_detect_lost_transition_state : State

@onready var pathing_timer = $PathingTimer

func enter():
	if actor == null:
		push_error("actor not assigned to Follow State, exiting state...")
	
	actor.set_follow_position()
	pathing_timer.start()

func exit():
	if not pathing_timer.is_stopped():
		pathing_timer.stop()

func physics_update(_delta : float):
	if actor.is_in_attack_range():
		if not actor.in_attack_cooldown:
			in_attack_range_transition()
	
	if actor.has_reached_destination():
		actor.stop()
	else:
		actor.set_follow_speed()
		actor.move(_delta)
	
	actor.set_animation_based_on_velocity()

func on_detect_exit_transition(_detected_body):
	actor.target_detect_state = self
	actor.set_last_known_direction(_detected_body.global_position)
	Transitioned.emit(self, on_detect_lost_transition_state.name.to_lower())

func in_attack_range_transition():
	Transitioned.emit(self, "attack")

func _on_pathing_timer_timeout():
	actor.set_follow_position()
