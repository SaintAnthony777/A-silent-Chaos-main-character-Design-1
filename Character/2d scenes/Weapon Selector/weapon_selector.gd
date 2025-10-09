extends Control

@onready var mendri_base_character: CharacterBody3D = $".."
@onready var weapon_selector: Control = $"."

@onready var avelyn: weapon = $"../Weapons equipped/Avelyn"
@onready var fists: weapon = $"../Weapons equipped/Fists"


var can_change_weapon:bool=true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func _process(_delta: float) -> void:
	pass 
func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("Weapon selector") and can_change_weapon: 
		weapon_selector.show()
		get_tree().paused=true
		Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_released("Weapon selector"):
		can_change_weapon=true
		

func _on_avelyn_mouse_entered() -> void:
	weapon_switch(avelyn)
func weapon_switch(weapon_to_switch:weapon):
	await get_tree().create_timer(.5).timeout
	weapon_selector.hide()
	get_tree().paused=false
	can_change_weapon=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	mendri_base_character.current_equipped_weapon=weapon_to_switch
func _on_fist_mouse_entered() -> void:
	weapon_switch(fists)
