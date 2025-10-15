extends Node

class_name weapon

var weapon_name:String
var weapon_damage:float
var attack_list:Array[String]
var attack_duration:Array[float]
@export var w_dmg:float
@export var w_name:String
@export var att_list:Array[String]
@export var att_dur:Array[float]
func _ready() -> void:
	weapon_damage=w_dmg
	weapon_name=w_name
	attack_list=att_list
	attack_duration=att_dur
func get_weapon_name()->String: return weapon_name
func  get_weapon_damage()->float:return weapon_damage
