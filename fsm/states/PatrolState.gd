extends State
class_name PatrolState

@export var actor : AIActor

@onready var patrol_timer = $PatrolTimer

func enter():
	if actor == null:
		push_error("Actor not assigned to Patrol State.")
	
	actor.move_speed = actor.walk_speed
	patrol_timer.start()
	
func physics_update(_delta : float):
	if actor.has_reached_destination():
		actor.animated_sprite.play("idle")
		actor.stop()
		if patrol_timer.is_stopped():
			patrol_timer.start()
	else:
		actor.move(_delta)

func exit():
	if not patrol_timer.is_stopped():
		patrol_timer.stop()

func _on_patrol_timer_timeout():
	actor.set_next_patrol_position()
	actor.animated_sprite.play("walk")
