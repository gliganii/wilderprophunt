extends MultiplayerSynchronizer

@export var jumping := false
@export var direction := Vector2()
@export var shooting := false
@export var sprinting := false
@export var inspecting := false
@export var taunting := false

func _ready():
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())

@rpc("call_local")
func jump():
	jumping = true
	
@rpc("call_local")
func shoot():
	shooting = true
	
@rpc("call_local")
func sprint():
	sprinting = true
	
@rpc("call_local")
func inspect():
	inspecting = true
	
@rpc("call_local")
func taunt():
	taunting = true
	
func _process(delta):
	direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if Input.is_action_just_pressed("click"):
		shoot.rpc()
	if Input.is_action_just_pressed("jump"):
		jump.rpc()
	if Input.is_action_just_pressed("sprint"):
		sprint.rpc()
	if Input.is_action_just_pressed("inspect"):
		inspect.rpc()
	if Input.is_action_just_pressed("taunt"):
		taunt.rpc()
