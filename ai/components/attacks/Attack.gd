extends Node2D
class_name Attack

signal on_start_telegraph
signal on_start_attack

@export var data = preload("res://ai/components/attacks/default_attack_data.tres")

var attack_range : float = 0
var telegraph_time : float = 0
var end_attack_time : float = 0

@onready var hitbox = $Hitbox
@onready var hitbox_shape = $Hitbox/CollisionShape2D
@onready var attack_effects = $Hitbox/AttackEffects

func _ready():
	if owner != null:
		hitbox.attack_owner = owner
	
	telegraph_time = data.telegraph_time
	end_attack_time = data.end_attack_time

func is_in_range(distance : float) -> bool:
	if distance <= attack_range:
		return true
	else: 
		return false

func toggle_hitbox(is_active : bool):
	if is_active:
		hitbox_shape.set_deferred("disabled", true)
	else:
		hitbox_shape.set_deferred("disabled", false)

func perform_attack(direction : Vector2):
	toggle_hitbox(true)
	look_at(owner.global_position + direction)
	attack_effects.play("wave")
	

func _on_telegraph_timer_timeout():
	pass # Replace with function body.


func _on_end_attack_timer_timeout():
	pass # Replace with function body.
