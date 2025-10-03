extends CharacterBody3D

@export_group("camera")
@export_range(0.0,1.0) var mouse_sensitivity:float=0.025

@export_group("Movement")
@export var move_speed:=5.0
@export var acceleration:=5.0
@export var rotation_speed:=6.0
@export var jump_impulse:=8.0

###variable controllant la direction de la camera soit dans physics process ou dans d'autres
var camera_input_direction:=Vector2.ZERO
var last_movement_direction:=Vector3.BACK
var gravity:=-15.0
var stopping_speed:=1.0

### variables pour les attaques
var attack_pattern:String
var attack_number:int=1
var is_attacking:bool=false
var can_attack:bool=true

var attack_speed:=1.0

signal start_attacking 


@onready var camera_pivot: Node3D = %Camera_pivot
@onready var camera: Camera3D = %Camera3D
@onready var character_mesh: Node3D = $"Mendri retravaillé 5"



func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("left click"):
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if Input.is_action_pressed("Pause"):
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("left click"):
		attack_stance()
func _unhandled_input(event: InputEvent) -> void:
	var camera_is_in_motion:=(
		event is InputEventMouseMotion and 
		Input.get_mouse_mode()==Input.MOUSE_MODE_CAPTURED
		)
	if camera_is_in_motion:
		camera_input_direction=event.screen_relative*mouse_sensitivity

func _physics_process(delta: float) -> void:
	
	camera_pivot.rotation.x+=camera_input_direction.y*delta
	camera_pivot.rotation.x=clamp(camera_pivot.rotation.x, -PI/6.0 , PI/3.0)
	camera_pivot.rotation.y-=camera_input_direction.x*delta
	
	camera_input_direction=Vector2.ZERO
	
	var raw_input:=Input.get_vector("gauche","droite","Haut","Bas")
	var forward:=camera.global_basis.z
	var right:=camera.global_basis.x
	
	var move_direction:=forward*raw_input.y + right*raw_input.x
	move_direction.y = 0.0
	move_direction=move_direction.normalized()
	
	var y_velocity:=velocity.y
	velocity.y = 0
	velocity = velocity.move_toward(move_direction*move_speed,acceleration*delta)
	velocity.y = y_velocity+gravity*delta
	
	var is_starting_jump:=(Input.is_action_just_pressed("Jump") and is_on_floor())
	if is_starting_jump:
		velocity.y+=jump_impulse
	if is_equal_approx(move_direction.length(),0.0) and velocity.length()<stopping_speed:
		velocity=Vector3.ZERO
	
	move_and_slide()
	if move_direction.length() > 0.2:
		last_movement_direction=move_direction
	var target_angle:=Vector3.BACK.signed_angle_to(last_movement_direction,Vector3.UP)
	character_mesh.global_rotation.y=lerp_angle(character_mesh.rotation.y,target_angle,rotation_speed*delta)
	
	
	if is_starting_jump:
		character_mesh.jumping()
	elif not is_on_floor() and velocity.y<0:
		character_mesh.falling()
	elif is_on_floor():
		var ground_speed:=velocity.length()
		if ground_speed>0.0:
			if !is_attacking:
				character_mesh.running()
			else :
				character_mesh.attacking("First Slash")
		else:
			character_mesh.idle()
func attack_stance():
	is_attacking=true
	can_attack=false
	var attack_duration:=2
	await get_tree().create_timer(attack_duration).timeout
	is_attacking=false
	var attack_cooldown:=1.0
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack=true
