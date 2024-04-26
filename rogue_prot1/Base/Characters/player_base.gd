@tool
extends CharacterBase
class_name PlayerBase


@onready var signature_skill : Skill = $SignatureSkill
@onready var player_engine : PlayerEngine = $PlayerEngine

func getDirection() -> Vector3:
	return player_engine.direction


func _get_configuration_warnings() -> PackedStringArray:
	var warnings:PackedStringArray = super._get_configuration_warnings()	
	_check_warning_search(func(x): return x is PlayerEngine, null, get_children(), "This character has no PlayerEngine. Consider adding an PlayerEngine as a child.", warnings)
	_check_warning_search(func(x): return x is Skill, "SignatureSkill", get_children(), "This character has no SignatureSkill. Consider adding an Skill named SignatureSkill as a child.", warnings)
	
	return warnings



func _on_pickup_area_entered(area):	
	if area.is_in_group("buffs"):
		var buff = area.get_buff()
		character_sheet.append_buff(buff)
		area.queue_free()
