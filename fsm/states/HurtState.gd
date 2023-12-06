extends State
class_name HurtState

@export var actor : AIActor
@onready var knockback_timer = $KnockbackTimer

func enter():
	if actor == null:
		push_error("actor not assigned to Follow State, exiting state...")
	
	actor.animated_sprite.play("hurt")
	actor.nav_agent.avoidance_enabled = false
	actor.move_speed = 100
	actor.set_knockback_position()
	actor.was_hit = false
	
	knockback_timer.start()

func exit():
	actor.nav_agent.avoidance_enabled = true
	actor.move_speed = 0
	actor.stop()
	actor.set_animation_based_on_velocity()

func physics_update(_delta : float):
	actor.move(_delta)


func _on_knockback_timer_timeout():
	if actor.is_in_attack_range() and not actor.in_attack_cooldown:
		Transitioned.emit(self, "attack")
	else:
		Transitioned.emit(self, "follow")
	
	
