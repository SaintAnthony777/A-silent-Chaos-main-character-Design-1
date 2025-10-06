extends Node

class_name weapon

var weapon_name:String
var weapon_damage:float
@export var w_dmg:float
@export var w_name:String
func _ready() -> void: weapon_damage=w_dmg;weapon_name=w_name
func get_weapon_name()->String: return weapon_name
func  get_weapon_damage()->float:return weapon_damage
