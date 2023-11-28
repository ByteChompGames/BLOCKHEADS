extends CharacterBody2D
class_name AIActor

enum States
{
	WAIT,
	WANDER,
	CHASE,
	FLEE
}
var state = States.WAIT

@export var move_speed = 25
@export var on_detect_state = States.CHASE
@export var detect_state_time = 3

var move_direction : Vector2 = Vector2.ZERO
var detect_target = null

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
			pass
		States.CHASE:
			move_direction = get_direction_to_target()
		States.FLEE:
			move_direction = -get_direction_to_target()
	
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

func _on_move_timer_timeout():
	wait_timer.start()
	state = States.WAIT
	animated_sprite.play("idle")


func _on_wait_timer_timeout():
	move_direction = get_random_direction()
	move_timer.start()
	state = States.WANDER
	animated_sprite.play("walk")


func _on_detection_range_body_entered(body):
	if body == self:
		return
	
	if detect_target == null:
		detect_target = body
		state = on_detect_state
		animated_sprite.play("walk")
		if not wait_timer.is_stopped():
			wait_timer.stop()
		if not move_timer.is_stopped():
			move_timer.stop()
	else:
		if body == detect_target:
			detect_timer.stop()


func _on_detection_range_body_exited(body):
	if body == self:
		return
	
	if body == detect_target:
		detect_timer.start()

func _on_detect_timer_timeout():
	detect_target = null
	state = States.WAIT
	wait_timer.start()
	animated_sprite.play("idle")
