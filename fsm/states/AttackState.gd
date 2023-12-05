extends State
class_name AttackState

@export var actor : AIActor
@export var animator : AnimatedSprite2D
@export var hitbox_shape : CollisionShape2D
@export var attack_effects : AnimatedSprite2D

@export var attack_finished_transition_state : State
@export var attack_interupt_transition_state : State

@onready var telegraph_timer = $TelegraphTimer
@onready var end_attack_timer = $EndAttackTimer

func enter():
	if actor == null:
		push_error("actor not assigned to Follow State, exiting state...")
	
	actor.nav_agent.avoidance_enabled = false
	hitbox_shape.set_deferred("disabled", true)
	telegraph_timer.start()
	animator.play("right_attack_tel")

func exit():
	if not telegraph_timer.is_stopped():
		telegraph_timer.stop()
	actor.move_speed = 0
	actor.stop()
	actor.nav_agent.avoidance_enabled = true

func physics_update(_delta : float):
	if not end_attack_timer.is_stopped():
		actor.move(_delta)

func _on_telegraph_timer_timeout():
	animator.play("right_attack")
	actor.move_speed = 100
	actor.set_follow_position()
	actor.perform_attack()
	hitbox_shape.set_deferred("disabled", false)
	attack_effects.play("wave")
	end_attack_timer.start()


func _on_end_attack_timer_timeout():
	hitbox_shape.set_deferred("disabled", true)
	Transitioned.emit(self, attack_finished_transition_state.name.to_lower())
