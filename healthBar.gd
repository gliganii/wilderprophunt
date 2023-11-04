extends Node2D
@export var player = CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	print(player.health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
