extends Control

var center : Vector2
@onready var node = get_parent().get_node("Control2")
@onready var vbox = get_parent().get_node("VBoxContainer")

func _ready():
	# calculate center of the screen
	pass 
	
func _process(_delta):
	pass

func _on_exit_game_pressed():
	get_tree().quit()
