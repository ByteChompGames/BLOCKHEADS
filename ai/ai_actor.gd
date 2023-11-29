extends CharacterBody2D
class_name AIActor

@export var follow_target : CharacterBody2D
@export var patrol_path : PatrolPath

@export var walk_speed = 25
@export var run_speed = 50
@export var wander_radius = 50

var move_speed = 0

@onready var nav_agent = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	move_and_slide()

func move(delta : float):
	var direction = to_local(nav_agent.get_next_path_position()).normalized() # set move direction to next point on navigation path
	var desired_velocity = direction * move_speed # set character velocity to move in direction at move speed
	
	var steering_force = desired_velocity - velocity
	velocity = velocity + (steering_force * delta)
	

func stop():
	velocity = Vector2.ZERO # reset character velocity

func set_wander_position():
	# get a random x and y value withing wander radius
	var x = randf_range(-wander_radius, wander_radius)
	var y = randf_range(-wander_radius, wander_radius)
	
	nav_agent.target_position = global_position + Vector2(x, y) # set position to random point from current position
	
	keep_navigation_path_reachable()

func keep_navigation_path_reachable():
	if nav_agent.get_final_position() != nav_agent.target_position: # if the target position cannot be reached
		nav_agent.target_position = nav_agent.get_final_position() # update target position to final position on path.

func set_follow_position():
	if not follow_target:
		return
	
	nav_agent.target_position = follow_target.global_position
	keep_navigation_path_reachable()

func set_next_patrol_position():
	if not patrol_path:
		return
	
	nav_agent.target_position = patrol_path.get_next_point()
	keep_navigation_path_reachable()

func has_reached_destination() -> bool:
	if nav_agent.distance_to_target() < nav_agent.target_desired_distance:
		return true
	else:
		return false
