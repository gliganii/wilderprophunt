extends MultiplayerSynchronizer

@export var jumping := false
@export var direction := Vector2()
@export var shooting := false
@export var bullet := false

func _ready():
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())

@rpc("call_local")
func jump():
	jumping = true
	
@rpc("call_local")
func shoot():
	shooting = true
	
@rpc("call_local")
func pewpew():
	bullet = true
	
func _process(delta):
	direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if Input.is_action_just_pressed("click"):
		shoot.rpc()
		pewpew.rpc()
	if Input.is_action_just_pressed("jump"):
		jump.rpc()
