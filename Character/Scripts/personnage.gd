extends CharacterBody3D

@export_group("camera")
@export_range(0.0,1.0) var mouse_sensitivity:float=0.025
@export var SPEED := 7.0
@export var JUMP_VELOCITY :=8.0

@onready var camera_controller: Node3D = %Camera_pivot
@onready var character_mesh: Node3D = $"Mendri retravaillé 5"
@onready var camera: Camera3D = %Camera3D

var camera_input_direction:=Vector2.ZERO
var last_movement_direction:=Vector3.BACK
var rotation_speed:=6.0
var gravity:=-19.0
var jump_impulse:=8.0
var start_jumping:=false
###Dash variables
var Isdashing:=false
var CanDash:=true
var dashspeed:=15.0


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("left click"):
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if Input.is_action_pressed("Pause"):
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("left click"):
		pass
	if Input.is_action_just_pressed("dashes") and CanDash:
		dashlogic(.7,.5)
func _unhandled_input(event: InputEvent) -> void:
	var camera_is_in_motion:=(
		event is InputEventMouseMotion and 
		Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED
		)
	if camera_is_in_motion:
		camera_input_direction=event.screen_relative*mouse_sensitivity

func _physics_process(delta: float) -> void:
	camera_controller.rotation.x+=camera_input_direction.y*delta
	camera_controller.rotation.x=clamp(camera_controller.rotation.x, -PI/6.0 , PI/3.0)
	camera_controller.rotation.y-=camera_input_direction.x*delta
	
	camera_input_direction=Vector2.ZERO
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_impulse
		
	var input_dir := Input.get_vector("droite", "gauche", "Bas", "Haut")
	var forward:=camera.global_basis.z
	var right:=camera.global_basis.x
	var move_direction:=forward*input_dir.y*-1 + right*input_dir.x*-1
	var direction := (camera_controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	move_direction.y = 0.0
	move_direction=move_direction.normalized()
	
	if Isdashing:
		var dashdirection=character_mesh.transform.basis.z.normalized()
		velocity=dashdirection*dashspeed
		velocity.y=0
	else:
		if direction :
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	###rotation du personnage
	if move_direction.length() > 0.2 and !Isdashing:
		last_movement_direction=move_direction
	var target_angle:=Vector3.BACK.signed_angle_to(last_movement_direction,Vector3.UP)
	character_mesh.global_rotation.y=lerp_angle(character_mesh.rotation.y,target_angle,rotation_speed*delta)
	
	moves_logics(velocity)
	move_and_slide()
	

func attacking():
	pass
func moves_logics(vel:Vector3):
	var ground_speed=vel.length()
	if is_on_floor():
		if ground_speed>=.2:
			if !Isdashing:
				character_mesh.running()
			else :
				character_mesh.dashing()
		else :
			character_mesh.idle()
	else :
		if Isdashing:
			character_mesh.dashing()
		elif vel.y>0 : character_mesh.jumping()
		else : character_mesh.falling()
		
func dashlogic(dashduration:float,dashcooldown:float):
	Isdashing=true
	CanDash=false
	await get_tree().create_timer(dashduration).timeout
	Isdashing=false
	await get_tree().create_timer(dashcooldown).timeout
	CanDash=true
