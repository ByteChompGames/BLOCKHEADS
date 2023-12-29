extends State
class_name FleeState

@export var on_detect_lost_transition_state : State

@onready var flee_timer = $FleeTimer
@onready var switch_direction_timer = $SwitchDirectionTimer

func enter():
	
	flee_timer.start()
	#switch_direction_timer.start()

func exit():
	if not flee_timer.is_stopped():
		flee_timer.stop()

func physics_update(_delta : float):
	owner.move(_delta)
	owner.set_animation_based_on_velocity()

func on_detect_exit_transition(_detected_body):
	owner.target_detect_state = self
	owner.set_last_known_direction(_detected_body.global_position)
	Transitioned.emit(self, on_detect_lost_transition_state.name.to_lower())
	owner.follow_target = null

func _on_flee_timer_timeout():
	owner.set_flee_position()


func _on_switch_direction_timer_timeout():
	owner.change_flee_direction()
