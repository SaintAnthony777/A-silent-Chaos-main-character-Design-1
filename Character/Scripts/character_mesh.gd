extends Node3D


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
