extends CharacterBody2D
class_name AIActor

@export var follow_target : CharacterBody2D

@export var walk_speed = 25
@export var run_speed = 50
@export var wander_radius = 50

var move_speed = 0
var detect_target = null

@onready var nav_agent = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	move_and_slide()

func move():
	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = direction * move_speed
	

func stop():
	velocity = Vector2.ZERO

func set_wander_position():
	var x = randf_range(-wander_radius, wander_radius)
	var y = randf_range(-wander_radius, wander_radius)
	
	nav_agent.target_position = global_position + Vector2(x, y)

func get_follow_target() -> CharacterBody2D:
	return follow_target

func set_follow_position():
	if not follow_target:
		return
	
	nav_agent.target_position = follow_target.global_position

func has_reached_destination() -> bool:
	if nav_agent.distance_to_target() < nav_agent.target_desired_distance:
		return true
	else:
		return false

func get_direction_to_target() -> Vector2:
	if detect_target == null:
		return Vector2.ZERO
	else:
		var direction = detect_target.global_position - global_position
		return direction.normalized()
