extends StaticBody3D

@export var health = 2

func hit(damage):
	health -= damage
	if health < 0:
		queue_free()
