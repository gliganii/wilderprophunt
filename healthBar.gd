extends Node2D

@export var value = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HBoxContainer/Label.text = str(value)
