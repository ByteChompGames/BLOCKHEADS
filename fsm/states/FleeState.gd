extends State
class_name FleeState

@export var actor : AIActor

@export var on_detect_lost_transition_state : State

@onready var flee_timer = $FleeTimer
@onready var switch_direction_timer = $SwitchDirectionTimer

func enter():
	if actor == null:
		push_error("actor not assigned to Flee State.")
	
	flee_timer.start()
	#switch_direction_timer.start()

func exit():
	if not flee_timer.is_stopped():
		flee_timer.stop()

func physics_update(_delta : float):
	actor.move(_delta)

func on_detect_exit_transition(_detected_body):
	actor.target_detect_state = self
	actor.set_last_known_direction(-_detected_body.global_position)
	Transitioned.emit(self, on_detect_lost_transition_state.name.to_lower())

func _on_flee_timer_timeout():
	actor.set_flee_position()


func _on_switch_direction_timer_timeout():
	actor.change_flee_direction()
