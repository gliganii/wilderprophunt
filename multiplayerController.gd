extends Node

@export var Address = "127.0.0.1"
@export var port = 7000
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func peer_connected(id):
	print("Player Connected: " + str(id))
	
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	PlayerManager.Players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()

func connected_to_server(id):
	print("Connected to Server")
	SendPlayerInformation.rpc_id(1, multiplayer.get_unique_id())

	
func connection_failed(id):
	print("Couldn't Connect")

@rpc("any_peer")
func SendPlayerInformation(id):
	if !PlayerManager.Players.has(id):
		PlayerManager.Players[id] ={
			"id" : id,
		}
	
	if multiplayer.is_server():
		for i in PlayerManager.Players:
			SendPlayerInformation.rpc(i)

#@rpc("any_peer","call_local")
#func StartGame():
#	var scene = load("res://map1.tscn").instantiate()
#	get_tree().root.add_child(scene)
#	self.hide()
	
func host_game():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("cannot host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	SendPlayerInformation(multiplayer.get_unique_id())

	print("Server Hosted")
	pass


func join_game():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	pass # Replace with function body.


#func start_game():
#	StartGame.rpc()
#	pass # Replace with function body.
