extends Node2D
class_name AvoidanceMap

@export var tick_rate = 0.2

var dangers = [0,0,0,0,0,0,0,0]
var hit_value = 5
var adjacent_value = 2
var ray_list: Array[RayCast2D]

@onready var ray_up = $up
@onready var ray_up_right = $up_right
@onready var ray_right = $right
@onready var ray_down_right = $down_right
@onready var ray_down= $down
@onready var ray_down_left = $down_left
@onready var ray_left = $left
@onready var ray_up_left = $up_left

@onready var check_rate = $CheckRate

func _ready():
	ray_list = [ray_up, ray_up_right, ray_right, ray_down_right, ray_down, ray_down_left, ray_left, ray_up_left]
	check_rate.wait_time = tick_rate
	check_rate.start()

func check_for_avoidance():
	dangers = [0,0,0,0,0,0,0,0]
	for i in dangers.size():
		set_danger(ray_list[i], i)
		if(dangers[i] == 5):
			var previous = i - 1
			if previous < 0:
				previous = dangers.size() -1
			if dangers[previous] == 0:
				dangers[previous] = 2
			var next = i + 1
			if next >= dangers.size():
				next = 0
			if dangers[next] == 0:
				dangers[next] = 2

func set_danger(ray : RayCast2D, id : int):
	if ray.is_colliding():
		dangers[id] = 5
	else:
		if dangers[id] != 2:
			dangers[id] = 0

func _on_check_rate_timeout():
	check_for_avoidance()
