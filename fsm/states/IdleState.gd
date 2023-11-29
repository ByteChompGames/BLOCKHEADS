extends State
class_name IdleState

@export var actor : AIActor

@onready var wait_timer = $WaitTimer

func enter():
	if actor == null:
		push_error("actor not assigned to Idle State, exiting state...")
		return
	
	actor.move_speed = actor.walk_speed
	wait_timer.start()

func exit():
	if not wait_timer.is_stopped():
		wait_timer.stop()

func physics_update(_delta : float):
	if actor.has_reached_destination():
		if wait_timer.is_stopped():
			actor.animated_sprite.play("idle")
			actor.stop()
			wait_timer.start()
	else:
		actor.move(_delta)
	

func _on_timer_timeout():
	actor.set_wander_position()
	actor.animated_sprite.play("walk")
