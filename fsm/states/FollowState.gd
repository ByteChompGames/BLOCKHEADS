extends State
class_name FollowState

@export var on_detect_lost_transition_state : State

@onready var pathing_timer = $PathingTimer

func enter():
	
	owner.set_follow_position()
	pathing_timer.start()

func exit():
	if not pathing_timer.is_stopped():
		pathing_timer.stop()

func physics_update(_delta : float):
	if owner.is_in_attack_range():
		if not owner.in_attack_cooldown:
			in_attack_range_transition()
	
	if owner.has_reached_destination():
		owner.stop()
	else:
		owner.set_follow_speed()
		owner.move(_delta)
	
	owner.set_animation_based_on_velocity()

func on_detect_exit_transition(_detected_body):
	owner.target_detect_state = self
	owner.set_last_known_direction(_detected_body.global_position)
	Transitioned.emit(self, on_detect_lost_transition_state.name.to_lower())
	owner.follow_target = null

func in_attack_range_transition():
	Transitioned.emit(self, "attack")

func _on_pathing_timer_timeout():
	owner.set_follow_position()
