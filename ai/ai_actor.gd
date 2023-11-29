extends CharacterBody2D
class_name AIActor

enum States
{
	WAIT,
	WANDER,
	CHASE,
	FLEE,
	INVESTIGATE
}
var state = States.WAIT

@export var walk_speed = 25
@export var run_speed = 50
@export var wander_radius = 50
@export var on_detect_state = States.CHASE
@export var detect_state_time = 3

var move_direction : Vector2 = Vector2.ZERO
var move_speed = 0
var detect_target = null
var investigate_position : Vector2 = Vector2.ZERO

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

func get_random_direction() -> Vector2:
	var x = randf_range(-1,1)
	var y = randf_range(-1,1)
	
	return Vector2(x,y).normalized()

func get_direction_to_target() -> Vector2:
	if detect_target == null:
		return Vector2.ZERO
	else:
		var direction = detect_target.global_position - global_position
		return direction.normalized()

func assign_detect_target(body):
	detect_target = body
	state = on_detect_state
	move_direction = get_direction_to_target()
	if on_detect_state == States.FLEE:
		move_direction = -move_direction
	
	animated_sprite.play("run")
