extends RigidBody3D

@export var health = 50

func hit(damage):
	health -= damage
	if health < 0:
		queue_free()
