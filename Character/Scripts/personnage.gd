extends CharacterBody3D

@export_group("camera")
@export_range(0.0,1.0) var mouse_sensitivity:float=0.025
@export var SPEED := 7.0
@export var JUMP_VELOCITY :=8.0

@onready var camera_controller: Node3D = %Camera_pivot
@onready var character: character_mesh = $"Mendri retravaillé 7"
@onready var camera: Camera3D = %Camera3D

#####Weapons on hand
@onready var Fists: weapon = $"Weapons equipped/Fists"
@onready var Avelyn: weapon = $"Weapons equipped/Avelyn"


###Camera Vars
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

### variables pour les armes equippées
var current_equipped_weapon:weapon
var can_switch_weapon:=true
var is_switching_weapon:=false
var weapon_to_switch:weapon

##variables pour les attaques
var is_attacking:bool=false
var can_attack:=true
var attack_lunge:=9.0
var combo_pattern:=0
var current_attack:="First Strike"



func _ready() -> void:
	current_equipped_weapon=Fists

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("left click"):
		Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	if Input.is_action_pressed("Pause"):
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("left click") and can_attack:
		stop_motion()
		attack_logic(
			current_equipped_weapon.attack_list,
			current_equipped_weapon.attack_duration,
			0.1
			)
	if Input.is_action_just_pressed("dashes") and CanDash and !is_attacking:
		dashlogic(.7,.5)
	if Input.is_action_just_pressed("Fists Switch") and current_equipped_weapon!=Fists and can_switch_weapon:
		stop_motion()
		weapon_Switch_to(Fists)
	if Input.is_action_just_pressed("Avelyn Switch") and current_equipped_weapon!=Avelyn and can_switch_weapon:
		stop_motion()
		weapon_Switch_to(Avelyn)
		
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
		var dashdirection=character.transform.basis.z.normalized()
		velocity=dashdirection*dashspeed
		velocity.y=0
	elif character.lunge:
		var attack_direction=character.transform.basis.z.normalized()
		velocity=attack_direction*9
	else:
		if !is_attacking and !is_switching_weapon:
			if direction :
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
	
	###rotation du personnage
	if move_direction.length() > 0.2 and !Isdashing and !character.lunge:
		last_movement_direction=move_direction
	var target_angle:=Vector3.BACK.signed_angle_to(last_movement_direction,Vector3.UP)
	character.global_rotation.y=lerp_angle(character.rotation.y,target_angle,rotation_speed*delta)
	
	moves_logics(velocity)
	move_and_slide()
	


func weapon_Switch_to(WP:weapon):
	is_switching_weapon=true
	can_switch_weapon=false
	weapon_to_switch=WP
	await get_tree().create_timer(.5).timeout
	current_equipped_weapon=WP
	can_switch_weapon=true
	is_switching_weapon=false
	
func moves_logics(vel:Vector3):
	var ground_speed=vel.length()
	if is_on_floor():
		if !is_switching_weapon:
			if ground_speed>=.2:
				if !Isdashing or !is_attacking:
					character.set_to_motion(current_equipped_weapon,"Runs")
				if Isdashing:
					character.set_to_jump_falls_dash("Dashes")
				if is_attacking:
					character.set_to_attack(current_equipped_weapon,current_attack)
			else :
				if !is_attacking:
					character.set_to_motion(current_equipped_weapon,"Idle")
				else :
					character.set_to_attack(current_equipped_weapon,current_attack)
		else :
			character.weapon_switch(weapon_to_switch)
	else :
		if Isdashing:
			character.set_to_jump_falls_dash("Dashes")
		elif vel.y>0 : character.set_to_jump_falls_dash("Jump start")
		else : character.set_to_jump_falls_dash("Falling Idle")
		
func dashlogic(dashduration:float,dashcooldown:float):
	Isdashing=true
	CanDash=false
	await get_tree().create_timer(dashduration).timeout
	Isdashing=false
	await get_tree().create_timer(dashcooldown).timeout
	CanDash=true
	
func attack_logic(attack_list:Array[String],attack_duration:Array[float],atk_cool:float):
	combo_pattern+=1
	if combo_pattern>attack_list.size()-1:combo_pattern=1
	if Isdashing : combo_pattern=0
	current_attack=attack_list[combo_pattern]
	is_attacking=true
	can_attack=false
	can_switch_weapon=false
	await get_tree().create_timer(attack_duration[combo_pattern]).timeout
	is_attacking=false
	await get_tree().create_timer(atk_cool).timeout
	can_attack=true
	can_switch_weapon=true

func stop_motion():
	velocity.x=0
	velocity.z=0
