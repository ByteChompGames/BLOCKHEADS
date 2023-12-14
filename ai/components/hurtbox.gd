extends Area2D
class_name Hurtbox

func _ready():
	connect("area_entered", Callable( self, "_on_area_entered"))


func _on_area_entered(hitbox : Hitbox):
	if hitbox == null:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
	
	if hitbox.owner != owner.follow_target:
		owner.follow_target = hitbox.owner
		print(owner.name, " new follow target is ", hitbox.owner.name)
