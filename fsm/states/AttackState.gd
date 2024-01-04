extends State
class_name AttackState

@export var attack_finished_transition_state : State
@export var target_null_transition : State

@export var comboCount : int = 1

@export var available_attacks : Array[Attack]
var selected_attack : Attack

var currentComboCount : int = 0

@onready var telegraph_timer = $TelegraphTimer
@onready var end_attack_timer = $EndAttackTimer

func enter():
	# select an attack
	select_attack();
	# set values to match select attack
	telegraph_timer.wait_time = selected_attack.data.telegraph_time
	end_attack_timer.wait_time = selected_attack.data.end_attack_time
	
	#owner.nav_agent.avoidance_enabled = false
	start_telegraph()

func exit():
	selected_attack.toggle_hitbox(false)
	
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
		owner.simple_move()
		#owner.move(_delta)

func select_attack():
	if available_attacks.size() == 0: # cannot select an attack if no attacks available
		print("No attacks available to ", owner.name, ". Leaving Attack State.")
		Transitioned.emit(self, attack_finished_transition_state.name.to_lower())
		return
	
	var select_id = 0 # default to first option
	if available_attacks.size() > 1: # if more options are available
		select_id = randi_range(0, available_attacks.size() - 1) # select a random attack
	else:
		select_id = 0 # only 1 attack to select from
		
	selected_attack = available_attacks[select_id] # set selected attack based on id

#returns the direction the attack should be performed
func get_attack_direction() -> Vector2:
	var attack_direction = Vector2.DOWN # default value to down
	
	if owner.follow_target: # if attacker has a target
		attack_direction = owner.follow_target.global_position - owner.global_position # get direction to target
		attack_direction = attack_direction.normalized() # normalize direction
	
	return attack_direction 

func was_hit_transition():
	Transitioned.emit(self, "hurt")

func on_target_null_transition():
	Transitioned.emit(self, target_null_transition.name.to_lower())

func _on_telegraph_timer_timeout():
	selected_attack.perform_attack(get_attack_direction()) # attack in given direction
	
	owner.animated_sprite.play_attack()
	owner.move_speed = 75
	owner.set_follow_position()
	end_attack_timer.start()


func _on_end_attack_timer_timeout():
	owner.move_speed = 0
	owner.stop()
	
	selected_attack.toggle_hitbox(false)
	currentComboCount += 1
	
	if currentComboCount < comboCount:
		start_telegraph()
	else:
		owner.in_attack_cooldown = true
		owner.global_attack_cooldown_timer.start()
		Transitioned.emit(self, attack_finished_transition_state.name.to_lower())

func start_telegraph():
	selected_attack.toggle_hitbox(false)
	telegraph_timer.wait_time = randf_range(selected_attack.data.telegraph_time, selected_attack.data.telegraph_time * 2)
	telegraph_timer.start()
	owner.animated_sprite.telegraph_attack()
