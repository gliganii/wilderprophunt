extends RigidBody3D

@export var health = 30

func hit(damage):
	health -= damage
	if health < 0:
		queue_free()
