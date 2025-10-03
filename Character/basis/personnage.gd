extends CharacterBody3D

@export_group("camera")
@export_range(0.0,1.0) var mouse_sensitivity:float=0.025

@export_group("Movement")
@export var move_speed:=2.0
@export var acceleration:=5.0
@export var rotation_speed:=6.0
@export var is_running:=false
@export var jump_impulse:=5.0

###variable controllant la direction de la camera soit dans physics process ou dans d'autres
var camera_input_direction:=Vector2.ZERO
var last_movement_direction:=Vector3.BACK
var gravity:=-30.0

@onready var camera_pivot: Node3D = %Camera_pivot
@onready var camera: Camera3D = %Camera3D
@onready var rogue: Node3D = %Rogue



func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("left click"):
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if Input.is_action_pressed("Pause"):
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	if Input.is_action_pressed("sprint") and is_on_floor():
		is_running=true
	if Input.is_action_just_released("sprint"):
		is_running=false
	
func _unhandled_input(event: InputEvent) -> void:
	var camera_is_in_motion:=(
		event is InputEventMouseMotion and 
		Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED
		)
	if camera_is_in_motion:
		camera_input_direction=event.screen_relative*mouse_sensitivity

func _physics_process(delta: float) -> void:
	if is_running:move_speed=5.0
	else :move_speed=2.0
	camera_pivot.rotation.x+=camera_input_direction.y*delta
	camera_pivot.rotation.x=clamp(camera_pivot.rotation.x, -PI/6.0 , PI/3.0)
	camera_pivot.rotation.y-=camera_input_direction.x*delta
	
	camera_input_direction=Vector2.ZERO
	
	var raw_input:=Input.get_vector("gauche","droite","Haut ","Bas")
	var forward:=camera.global_basis.z
	var right:=camera.global_basis.x
	
	var move_direction:=forward*raw_input.y+right*raw_input.x
	move_direction.y = 0.0
	move_direction=move_direction.normalized()
	
	var y_velocity:=velocity.y
	velocity.y = 0
	velocity = velocity.move_toward(move_direction*move_speed,acceleration*delta)
	velocity.y = y_velocity+gravity*delta
	var is_starting_jump:=(Input.is_action_just_pressed("Jump") and is_on_floor())
	if is_starting_jump:
		velocity.y+=jump_impulse
	
	move_and_slide()
	if move_direction.length() > 0.2:
		last_movement_direction=move_direction
	var target_angle:=Vector3.BACK.signed_angle_to(last_movement_direction,Vector3.UP)
	rogue.global_rotation.y=lerp_angle(rogue.rotation.y,target_angle,rotation_speed*delta)
	
	if is_starting_jump:
		rogue.jumping()
	elif not is_on_floor() and velocity.y<0:
		rogue.falling()
	elif is_on_floor():
		var ground_speed:=velocity.length()
		if ground_speed>0.0:
			if is_running:rogue.running()
			else :rogue.walking()
		else:
			rogue.idle()
