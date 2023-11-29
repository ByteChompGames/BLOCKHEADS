extends State
class_name IdleState

@export var actor : AIActor
@export var nav_agent : NavigationAgent2D
@export var wait_timer : Timer

func enter():
	if actor == null:
		push_error("actor not assigned to Idle State, exiting state...")
	
	actor.move_speed = actor.walk_speed
	#actor.set_wander_position()
	wait_timer.start()

func exit():
	if not wait_timer.is_stopped():
		wait_timer.stop()

func physics_update(_delta : float):
	
	
	
	if nav_agent.distance_to_target() < nav_agent.target_desired_distance:
		if wait_timer.is_stopped():
			actor.animated_sprite.play("idle")
			actor.stop()
			wait_timer.start()
	else:
		actor.move()
	

func _on_timer_timeout():
	actor.set_wander_position()
	actor.animated_sprite.play("walk")
