extends Node3D

const SPEED = 40.0
@export var damage = 5
@export var player = CharacterBody3D
@onready var ray = $RayCast3D
@onready var mesh = $MeshInstance3D

func _process(delta):
	position += transform.basis * Vector3(0, -SPEED, 0) * delta
	if ray.is_colliding():
		mesh.visible = false
		ray.enabled = false
		if ray.get_collider().is_in_group("propPlayers"):
			ray.get_collider().hit(damage)
		else:
			player.hit(damage)
		await get_tree().create_timer(1.0).timeout
		queue_free()

func _on_timer_timeout():
	queue_free()
