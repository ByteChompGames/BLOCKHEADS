extends State
class_name FleeState

@export var actor : AIActor

@onready var flee_timer = $FleeTimer
@onready var switch_direction_timer = $SwitchDirectionTimer

func enter():
	if actor == null:
		push_error("actor not assigned to Flee State.")
	
	flee_timer.start()
	switch_direction_timer.start()

func exit():
	if not flee_timer.is_stopped():
		flee_timer.stop()

func physics_update(_delta : float):
	actor.move(_delta)

func _on_flee_timer_timeout():
	actor.set_flee_position()


func _on_switch_direction_timer_timeout():
	actor.change_flee_direction()
