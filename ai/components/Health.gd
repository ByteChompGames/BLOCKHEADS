extends Node
class_name Health

@export var current_health : int = 0
@export var critical_condition : int = 30

enum Condition
{
	FULL,
	DAMAGED,
	CRITICAL,
	DEAD
}

var health_condition = Condition.FULL
var max_health : int = 0
var heal_amount :int = 0

@onready var heal_timer = $HealTimer

# setup values of the health component
func initialize(max_health : int, heal_rate : float, heal_amount : int):
	self.max_health = max_health
	heal_timer.wait_time = heal_rate
	self.heal_amount = heal_amount
	reset()
	set_health_condition()

# set the condition to match the current health value
func set_health_condition():
	if current_health == max_health:
		health_condition = Condition.FULL
	elif current_health < max_health and current_health > critical_condition:
		health_condition = Condition.DAMAGED
	elif current_health <= critical_condition and current_health > 0:
		health_condition = Condition.CRITICAL
	elif current_health <= 0:
		health_condition = Condition.DEAD

# reset health back to starting values
func reset():
	current_health = max_health;

# reduce current health by given value
func receive_damage(amount : int):
	current_health -= amount
	set_health_condition()

func start_healing():
	if heal_timer.is_stopped():
		heal_timer.start()

func stop_healing():
	if not heal_timer.is_stopped():
		heal_timer.stop()

# increase current health by given value
func heal(amount : int):
	current_health += amount
	
	if current_health >= max_health: # do not heal past max health value
		reset()
		stop_healing()
	
	set_health_condition()

func _on_heal_timer_timeout():
	heal(heal_amount)
