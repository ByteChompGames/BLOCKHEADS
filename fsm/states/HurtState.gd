extends State
class_name HurtState

@onready var knockback_timer = $KnockbackTimer

func enter():
	if owner == null:
		push_error("owner not assigned to Follow State, exiting state...")
	
	owner.animated_sprite.play("hurt")
	owner.nav_agent.avoidance_enabled = false
	owner.move_speed = 100
	owner.set_knockback_position()
	owner.was_hit = false
	
	knockback_timer.start()

func exit():
	owner.nav_agent.avoidance_enabled = true
	owner.move_speed = 0
	owner.stop()
	owner.set_animation_based_on_velocity()

func physics_update(_delta : float):
	owner.move(_delta)


func _on_knockback_timer_timeout():
	if owner.health.health_condition == Health.Condition.DEAD:
		owner.queue_free()
		return
	elif owner.health.health_condition == Health.Condition.CRITICAL:
		Transitioned.emit(self, "flee")
	
	if owner.is_in_attack_range() and not owner.in_attack_cooldown:
		Transitioned.emit(self, "attack")
	else:
		Transitioned.emit(self, "follow")
	
	
