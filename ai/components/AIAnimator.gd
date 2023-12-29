extends AnimatedSprite2D
class_name AIAnimator

var walk_speed = 0
var run_speed = 0
var last_attack_side : int = 0

func initialize(walk_value : float, run_value : float):
	walk_speed = walk_value
	run_speed = run_value

func move(move_speed : float):
	if move_speed < walk_speed:
		play("idle")
	elif move_speed >= walk_speed and move_speed < run_speed:
		play("walk")
	else:
		play("run")

func hurt():
	play("hurt")

# play telegraph animation that does not match the last attack animation used
func telegraph_attack():
	match last_attack_side:
		0: # if last attack was right
			play("left_attack_tel") # play left
		1: # if last attack was left
			play("right_attack_tel") # play right

# play the telegraph animation that matched the given side
func telegraph_givem_attack(side : int):
	match side:
		0: # right
			play("right_attack_tel")
		1: # left
			play("left_attack_tel")

# play the attack animation that does not match the last attack used
func play_attack():
	match last_attack_side:
		0: # if last attack was right
			play("left_attack") # play left
			last_attack_side = 1 # update last attack to left
		1: # if last attack was left
			play("right_attack") # play right
			last_attack_side = 0 # update last attack to right

# play the attack animation that matched the given side
func play_given_attack(side : int):
	match side:
		0: # right
			play("right_attack")
			last_attack_side = 0
		1: # left
			play("left_attack")
			last_attack_side = 1
