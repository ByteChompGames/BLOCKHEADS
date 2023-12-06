extends Node
class_name State

signal Transitioned

func enter():
	pass

func exit():
	pass

func update(_delta : float):
	pass

func physics_update(_delata : float):
	pass

# Transitions

func on_detect_enter_transition(_detected_body):
	pass

func on_detect_exit_transition(_detected_body):
	pass

func in_attack_range_transition():
	pass
