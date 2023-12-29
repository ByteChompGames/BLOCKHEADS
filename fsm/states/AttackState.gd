extends State
class_name AttackState

@export var animator : AnimatedSprite2D
@export var hitbox_shape : CollisionShape2D
@export var attack_effects : AnimatedSprite2D

@export var attack_finished_transition_state : State
@export var on_target_null_transition_state : State

@export var comboCount = 1

var currentComboCount = 0
var telegraph_time = 0.5

@onready var telegraph_timer = $TelegraphTimer
@onready var end_attack_timer = $EndAttackTimer

func enter():
	if owner == null:
		push_error("owner not assigned to Follow State, exiting state...")
	
	owner.nav_agent.avoidance_enabled = false
	attack_effects.animation = "wave"
	start_telegraph()

func exit():
	if not telegraph_timer.is_stopped():
		telegraph_timer.stop()
	if not end_attack_timer.is_stopped():
		end_attack_timer.stop()
	
	owner.move_speed = 0
	owner.stop()
	owner.nav_agent.avoidance_enabled = true
	currentComboCount = 0

func physics_update(_delta : float):
	if owner.follow_target == null:
		on_target_null_transition()
	
	if not end_attack_timer.is_stopped():
		owner.move(_delta)

func was_hit_transition():
	if end_attack_timer.is_stopped():
		Transitioned.emit(self, "hurt")

func _on_telegraph_timer_timeout():
	owner.play_attack()
	owner.move_speed = 100
	owner.set_follow_position()
	owner.perform_attack()
	hitbox_shape.set_deferred("disabled", false)
	attack_effects.play("wave")
	end_attack_timer.start()


func _on_end_attack_timer_timeout():
	owner.move_speed = 0
	hitbox_shape.set_deferred("disabled", true)
	currentComboCount += 1
	
	if currentComboCount < comboCount:
		start_telegraph()
	else:
		owner.in_attack_cooldown = true
		owner.global_attack_cooldown_timer.start()
		Transitioned.emit(self, attack_finished_transition_state.name.to_lower())

func start_telegraph():
	hitbox_shape.set_deferred("disabled", true)
	
	telegraph_timer.wait_time = randf_range(telegraph_time, telegraph_time * 2)
	telegraph_timer.start()
	owner.play_attack_telegraph()

func on_target_null_transition():
	Transitioned.emit(self, on_target_null_transition_state.name.to_lower())
