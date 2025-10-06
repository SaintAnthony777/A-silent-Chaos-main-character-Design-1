extends Node3D
class_name character_mesh

func idle():
	$AnimationTree.set("parameters/Final Output/transition_request","Moves")
	$AnimationTree.set("parameters/Moving transitions/transition_request","Idle")
func running():
	$AnimationTree.set("parameters/Final Output/transition_request","Moves")
	$AnimationTree.set("parameters/Moving transitions/transition_request","Runs")
func falling():
	$AnimationTree.set("parameters/Final Output/transition_request","Jumps")
	$AnimationTree.set("parameters/Jumping Outputs/transition_request","Falling Idle")
func walking():
	$AnimationTree.set("parameters/Final Output/transition_request","Moves")
	$AnimationTree.set("parameters/Moving transitions/transition_request","Walks")
func jumping():
	$AnimationTree.set("parameters/Final Output/transition_request","Jumps")
	$AnimationTree.set("parameters/Jumping Outputs/transition_request","Jump start")
func dashing():
	$AnimationTree.set("parameters/Final Output/transition_request","Moves")
	$AnimationTree.set("parameters/Moving transitions/transition_request","Dashes")
func attacking(attack_pattern:String):
	$AnimationTree.set("parameters/Final Output/transition_request","Attacks")
	$AnimationTree.set("parameters/Attacking Transitions/transition_request",attack_pattern)


func set_to_motion(current_weapon:weapon,current_action:String):
	$AnimationTree.set("parameters/Final Output/transition_request","Moves")
	$AnimationTree.set("parameters/moves Weapon equipped  /transition_request",current_weapon.get_weapon_name())
	$AnimationTree.set("parameters/"+current_weapon.get_weapon_name()+" Moving transitions/transition_request",current_action)
func set_to_jump_falls_dash(current_action:String):
	$AnimationTree.set("parameters/Final Output/transition_request","Miscs")
	$AnimationTree.set("parameters/Miscs outputs/transition_request",current_action)
func set_to_attack(current_weapon:weapon):
	pass
