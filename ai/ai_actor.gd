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
@export var wander_min_max = Vector2(1, 2)
@export var on_detect_state = States.CHASE
@export var detect_state_time = 3

var move_direction : Vector2 = Vector2.ZERO
var move_speed = 0
var detect_target = null
var investigate_position : Vector2 = Vector2.ZERO

@onready var move_timer = $WanderTimer
@onready var wait_timer = $WaitTimer
@onready var animated_sprite = $AnimatedSprite2D
@onready var detect_timer = $DetectTimer


func _ready():
	wait_timer.start()
	detect_timer.wait_time = detect_state_time

func _physics_process(delta):
	
	match state:
		States.WAIT:
			move_direction = Vector2.ZERO
		States.WANDER:
			move_speed = walk_speed
		States.CHASE:
			move_speed = run_speed
			move_direction = get_direction_to_target()
		States.FLEE:
			move_speed = run_speed
		States.INVESTIGATE:
			move_speed = run_speed
			var distance_to_investigate_point = global_position.distance_to(investigate_position)
			if distance_to_investigate_point < 5:
				detect_target = null
				wait_timer.start()
				state = States.WAIT
				animated_sprite.play("idle")
	
	velocity = move_direction * move_speed
	move_and_slide()

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
	if not wait_timer.is_stopped():
		wait_timer.stop()
	if not move_timer.is_stopped():
		move_timer.stop()

func _on_move_timer_timeout():
	wait_timer.start()
	state = States.WAIT
	animated_sprite.play("idle")

func _on_wait_timer_timeout():
	move_direction = get_random_direction()
	move_timer.wait_time = randf_range(wander_min_max.x, wander_min_max.y)
	move_timer.start()
	state = States.WANDER
	animated_sprite.play("walk")


func _on_detection_range_body_entered(body):
	if body == self:
		return
	
	if body.is_in_group("actor"):
		if detect_target == null:
			assign_detect_target(body)
		else:
			if body == detect_target:
				detect_timer.stop()
				get_direction_to_target()
				if state == States.INVESTIGATE:
					state = on_detect_state


func _on_detection_range_body_exited(body):
	if body == self:
		return
	
	if body == detect_target:
		if state == States.FLEE:
			detect_timer.start()
		if state == States.CHASE:
			investigate_position = body.global_position
			var direction = investigate_position - global_position
			move_direction = direction.normalized()
			state = States.INVESTIGATE

func _on_detect_timer_timeout():
	detect_target = null
	state = States.WAIT
	wait_timer.start()
	animated_sprite.play("idle")


func _on_detection_bounds_body_entered(body):
	if body.is_in_group("terrain"):
		var direction = body.global_position - global_position
		direction = direction.normalized()
		if abs(direction.x) > 0.5:
			move_direction.x *= -1
		if abs(direction.y) > 0.5:
			move_direction.y *= -1
