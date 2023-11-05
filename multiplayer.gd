extends Node

const PORT = 4433

func _ready():
#	get_tree().paused = true
	multiplayer.server_relay = false
	
	if DisplayServer.get_name() == "headless":
		print("Automatically starting dedicated server.")
		_on_host_pressed.call_deferred()
	
func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	start_game()
	
func _on_connect_pressed():
	var peer = ENetMultiplayerPeer.new()
	var connection : String = $UI/TextEdit.text
	if connection == "":
		OS.alert("Need a remote to connect to")
		return
	peer.create_client(connection, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
	start_game()
	
func start_game():
	$UI.hide()
#	get_tree().paused = false
	if multiplayer.is_server():
		change_level.call_deferred(load("res://map1.tscn"))

func _on_exit_game_button_pressed():
	get_tree().quit()
	
func change_level(scene: PackedScene):
	var level = $level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	level.add_child(scene.instantiate())
	
func _input(event):
	if not multiplayer.is_server():
		return
	if event.is_action("ui_home") and Input.is_action_just_pressed("ui_home"):
		change_level.call_deferred(load("res://map1.tscn"))
