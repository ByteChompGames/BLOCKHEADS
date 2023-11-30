extends CharacterBody2D
class_name AIActor

@export var follow_target : CharacterBody2D
@export var patrol_path : PatrolPath

@export var walk_speed = 25
@export var run_speed = 50
@export var wander_radius = 50

var move_speed = 0
var clockwise = true

@onready var nav_agent = $NavigationAgent2D
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	set_animation_based_on_velocity()

func set_animation_based_on_velocity():
	if move_speed < walk_speed:
		animated_sprite.play("idle")
	elif move_speed >= walk_speed and move_speed < run_speed:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("run")

# Movement
func move(delta : float):
	var direction = to_local(nav_agent.get_next_path_position()).normalized() # set move direction to next point on navigation path
	var desired_velocity = direction * move_speed # set character velocity to move in direction at move speed
	
	# steer towards the desired direction over time
	var steering_force = desired_velocity - velocity
	var new_velocity = velocity + (steering_force * delta)
	
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)

func stop():
	move_speed = 0
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(Vector2.ZERO)
	else:
		_on_navigation_agent_2d_velocity_computed(Vector2.ZERO)

# Navigation
func has_reached_destination() -> bool:
	# return true if target position is closer than the desired distance
	if nav_agent.is_target_reached():
		return true
	else:
		return false

func keep_navigation_path_reachable():
	if nav_agent.get_final_position() != nav_agent.target_position: # if the target position cannot be reached
		nav_agent.target_position = nav_agent.get_final_position() # update target position to final position on path.

# Wandering
func set_wander_position():
	# get a random x and y value withing wander radius
	var x = randf_range(-wander_radius, wander_radius)
	var y = randf_range(-wander_radius, wander_radius)
	
	move_speed = walk_speed
	nav_agent.target_position = global_position + Vector2(x, y) # set position to random point from current position
	
	keep_navigation_path_reachable()

# Following
func set_follow_position():
	if not follow_target: # cannot set follow position if no target available
		return
	
	# set target position to follow target, then ensure that position is reachable
	nav_agent.target_position = follow_target.global_position
	keep_navigation_path_reachable()

func set_follow_speed():
	if not follow_target: # cannot set speed if not target available
		return
	
	var run_distance = nav_agent.target_desired_distance * 2
	
	if nav_agent.distance_to_target() > run_distance:
		move_speed = run_speed
	else:
		move_speed = walk_speed

# Patrolling
func set_next_patrol_position():
	if not patrol_path: # cannot set a patrol position if no path provided
		return
	
	move_speed = walk_speed
	
	# set target position to the next point in the path
	nav_agent.target_position = patrol_path.get_next_point()
	keep_navigation_path_reachable()

#Flee
func set_flee_position():
	if not follow_target: # cannot flee if no target provided
		return
	
	var target_direction = follow_target.global_position - global_position # get direction to target
	target_direction = target_direction.normalized() # normalize direction
	
	# get the perpendicular direction to target
	var perp_direction = Vector2.ZERO
	if clockwise:
		perp_direction = get_perpendicular_vector_clockwise(target_direction)
	else:
		perp_direction = get_perpendicular_vector_counter(target_direction)
	
	move_speed = run_speed
	
	# set target direction to perpendiculat direction
	nav_agent.target_position = global_position + (perp_direction * (move_speed + nav_agent.target_desired_distance))
	keep_navigation_path_reachable()

func get_perpendicular_vector_clockwise(direction : Vector2) -> Vector2:
	var perp_direction = Vector2(direction.y, -direction.x) # get clockwise perpendicular direction
	return perp_direction

func get_perpendicular_vector_counter(direction : Vector2) -> Vector2:
	var perp_direction = Vector2(-direction.y, direction.x) # get counter-clockwise perpendicular direction
	return perp_direction

func change_flee_direction():
	clockwise = !clockwise


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
