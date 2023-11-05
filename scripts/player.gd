extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const GRAVITY = 10
const RUNNING_SPEED_MULTIPLIER = 2.0
# TODO: read from config file when settings are setup
const MOUSE_SENSITIVITY = 0.002

# Set by the authority, synchronized on spawn.
@export var player := 1 :
	set(id):
		player = id
		$PlayerInput.set_multiplayer_authority(id)

@onready var input = $PlayerInput

@onready var gun_barrel = $HunterCamera/gun/barrel
@onready var prop_selector = $PropCamera/propSelector
var bullet = load("res://weapons/bullet.tscn")
var walk_sound = preload("res://sounds/interactions/Walking.mp3")
var taunt = preload("res://sounds/taunts/Roxen_Mash.mp3")
var camera
@export var is_prop = false
@export var health = 100
@export var bullets = 20

func _ready():
	if is_prop == true:
#		remove_child($HunterCamera)
		camera = $PropCamera
		add_to_group("hunters")
	else:
#		remove_child($PropCamera)
		camera = $HunterCamera
		add_to_group("propPlayers")
	
	if player == multiplayer.get_unique_id():
		camera.current = true

func _physics_process(delta):
	$healthBar.value = health
	$bulletBar.value = bullets
	
	var speed_multiplier = 1.0
	
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Handle Jump.
	if input.jumping and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	input.jumping = false
		
	if Input.is_action_pressed("sprint") and is_on_floor():
		speed_multiplier = RUNNING_SPEED_MULTIPLIER
		
	if Input.is_action_pressed("taunt"):
		if !$AudioStreamPlayer3D.is_playing():
			$AudioStreamPlayer3D.stream = taunt
			$AudioStreamPlayer3D.play()
			$AnimationPlayer.play("inspect_weapon_opti")

	var direction = (transform.basis * Vector3(input.direction.x, 0, input.direction.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * speed_multiplier
		velocity.z = direction.z * SPEED * speed_multiplier
		if !$AudioStreamPlayer3D.is_playing():
			$AudioStreamPlayer3D.stream = walk_sound
			$AudioStreamPlayer3D.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * speed_multiplier)
		velocity.z = move_toward(velocity.z, 0, SPEED * speed_multiplier)

	move_and_slide()

		
func hit(damage):
	health -= damage
	if health < 0:
		#TODO: show death screen
		queue_free()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if   event.is_action_pressed("click"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else: if input.shooting:
			input.shooting = false
			$AnimationPlayer.play("weapon_shoot_opti")
			var instance = preload("res://weapons/bullet.tscn").instantiate()
			instance.player = self
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(40), deg_to_rad(60))

	if event.is_action_pressed("select_prop") and is_prop == true:
		if prop_selector.is_colliding() and prop_selector.get_collider().is_in_group("props"):
			var prop = prop_selector.get_collider()
			
			var character = prop.get_child(0).duplicate()
			var collisionShape = prop.get_child(1).duplicate()
			
			for child in $model.get_children():
				child.free()
			$collisionShape.replace_by(collisionShape)
			$model.replace_by(character)
			
			$model.scale = character.scale * prop.scale
			$collisionShape.scale = collisionShape.scale * prop.scale
			health = prop.health
			
		
func pickRoleSwitchCameras():
	if is_prop == true:
		print("Prop picked!")
		camera = $PropCamera
	else:
		print("Hunter picked!")
		camera = $HunterCamera
	
	if player == multiplayer.get_unique_id():
		camera.current = true
	remove_child($PickControl)

func _on_hunter_pick_button_button_down():
	is_prop = false
	pickRoleSwitchCameras()
	pass # Replace with function body.


func _on_prop_pick_button_button_down():
	is_prop = true
	pickRoleSwitchCameras()
	pass # Replace with function body.
