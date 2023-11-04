extends Control

var center : Vector2
@onready var node = $Control2

func _ready():
	# calculate center of the screen
	center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)

func _process(_delta):
	var tween = node.create_tween()
	# calculate the vector between mouse and center, than take only 10% of the value 
	var offset = center - get_global_mouse_position() * 0.1
	tween.tween_property(node, "position", offset, 1.0)

func start_game():
	get_tree().change_scene_to_file("res://map1.tscn")

func _on_exit_game_pressed():
	get_tree().quit()


func _on_start_pressed():
	start_game()
	MultiplayerController.join_game()


func _on_find_game_button_down():
	start_game()
	MultiplayerController.host_game()
