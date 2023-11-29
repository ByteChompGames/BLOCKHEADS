extends State
class_name FollowState

@export var actor : AIActor

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
	
	actor.move_speed = actor.walk_speed

func exit():
	if not pathing_timer.is_stopped():
		pathing_timer.stop()

func physics_update(_delata : float):
	if actor.has_reached_destination():
		actor.animated_sprite.play("idle")
		actor.stop()
	else:
		actor.move()
		actor.animated_sprite.play("run")


func _on_pathing_timer_timeout():
	actor.set_follow_position()
