extends State
class_name AttackState

@export var actor : AIActor
@export var animator : AnimatedSprite2D
@export var hitbox_shape : CollisionShape2D
@export var attack_effects : AnimatedSprite2D

@export var attack_finished_transition_state : State

@export var comboCount = 1

var currentComboCount = 0
var telegraph_time = 0.5

@onready var telegraph_timer = $TelegraphTimer
@onready var end_attack_timer = $EndAttackTimer

func enter():
	if actor == null:
		push_error("actor not assigned to Follow State, exiting state...")
	
	actor.nav_agent.avoidance_enabled = false
	
	start_telegraph()

func exit():
	if not telegraph_timer.is_stopped():
		telegraph_timer.stop()
	actor.move_speed = 0
	actor.stop()
	actor.nav_agent.avoidance_enabled = true
	currentComboCount = 0

func physics_update(_delta : float):
	if not end_attack_timer.is_stopped():
		actor.move(_delta)

func was_hit_transition():
	if end_attack_timer.is_stopped():
		Transitioned.emit(self, "hurt")

func _on_telegraph_timer_timeout():
	actor.play_attack()
	actor.move_speed = 100
	actor.set_follow_position()
	actor.perform_attack()
	hitbox_shape.set_deferred("disabled", false)
	attack_effects.play("wave")
	end_attack_timer.start()


func _on_end_attack_timer_timeout():
	actor.move_speed = 0
	hitbox_shape.set_deferred("disabled", true)
	currentComboCount += 1
	
	if currentComboCount < comboCount:
		start_telegraph()
	else:
		actor.in_attack_cooldown = true
		actor.global_attack_cooldown_timer.start()
		Transitioned.emit(self, attack_finished_transition_state.name.to_lower())

func start_telegraph():
	hitbox_shape.set_deferred("disabled", true)
	
	telegraph_timer.wait_time = randf_range(telegraph_time, telegraph_time * 2)
	telegraph_timer.start()
	actor.play_attack_telegraph()
