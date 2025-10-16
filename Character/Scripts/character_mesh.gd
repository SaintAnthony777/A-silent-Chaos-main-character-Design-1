extends Node3D
class_name character_mesh
var lunge:=false
func set_to_motion(current_weapon:weapon,current_action:String):
	$AnimationTree.set("parameters/Final Output/transition_request","Moves")
	$AnimationTree.set("parameters/moves Weapon equipped  /transition_request",current_weapon.get_weapon_name())
	$AnimationTree.set("parameters/"+current_weapon.get_weapon_name()+" Moving transitions/transition_request",current_action)
func set_to_jump_falls_dash(current_action:String):
	$AnimationTree.set("parameters/Final Output/transition_request","Miscs")
	$AnimationTree.set("parameters/Miscs outputs/transition_request",current_action)
func set_to_attack(current_weapon:weapon,current_attack_pattern:String):
	$AnimationTree.set("parameters/Final Output/transition_request","Attacks")
	$AnimationTree.set("parameters/attacks weapon equipped/transition_request",current_weapon.get_weapon_name())
	$AnimationTree.set("parameters/"+current_weapon.get_weapon_name()+" attack Transitions/transition_request",current_attack_pattern)
func weapon_switch(weapon_to_switch:weapon):
	$AnimationTree.set("parameters/Final Output/transition_request","Miscs")
	$AnimationTree.set("parameters/Miscs outputs/transition_request","Weapon Switch")
	$AnimationTree.set("parameters/Weapon Switch/transition_request",weapon_to_switch.get_weapon_name())
	$"Weapon Switcher Node/Weapon Switch Animator".play(weapon_to_switch.get_weapon_name()+" Takeout")
func start_lunges():
	lunge=true
func stop_lunges():
	lunge=false
