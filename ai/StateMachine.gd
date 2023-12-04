extends Node

@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transitioned)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func on_child_transitioned(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state


func _on_detection_range_body_entered(body):
	if body == current_state.actor:
		return
	
	if body.is_in_group("actor"):
		current_state.on_detect_enter_transition(body)


func _on_detection_range_body_exited(body):
	if body == current_state.actor:
		return
	
	if body.is_in_group("actor"):
		current_state.on_detect_exit_transition(body)
