extends Area2D
class_name Hurtbox

func _ready():
	connect("area_entered", Callable( self, "_on_area_entered"))


func _on_area_entered(hitbox : Hitbox):
	if hitbox == null:
		return
	
	if owner.has_method("receive_hit"):
		var hit_direction = hitbox.global_position - owner.global_position
		owner.receive_hit(hitbox.damage, hit_direction.normalized())
	
	if hitbox.attack_owner != owner.follow_target:
		owner.follow_target = hitbox.attack_owner
		print(owner.name, " new follow target is ", hitbox.attack_owner.name)
