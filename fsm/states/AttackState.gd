extends State
class_name AttackState

@export var actor : AIActor
@export var animator : AnimatedSprite2D

@export var attack_finished_transition_state : State
@export var attack_interupt_transition_state : State

@onready var telegraph_timer = $TelegraphTimer
@onready var end_attack_timer = $EndAttackTimer

func enter():
	if actor == null:
		push_error("actor not assigned to Follow State, exiting state...")
	
	telegraph_timer.start()
	animator.play("right_attack_tel")

func exit():
	if not telegraph_timer.is_stopped():
		telegraph_timer.stop()


func _on_telegraph_timer_timeout():
	animator.play("right_attack")
	end_attack_timer.start()


func _on_end_attack_timer_timeout():
	Transitioned.emit(self, attack_finished_transition_state.name.to_lower())
