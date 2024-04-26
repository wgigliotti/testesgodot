@tool
extends CharacterBase

class_name MobBase


func _physics_process(delta):
	if  Engine.is_editor_hint():			
		return
	
	if dead:
		velocity.y -= 2 * delta 	
	else:
		refreshAnimation()	
		
	if not is_on_floor() and not dead:
		velocity.y -= gravity * delta
	
	move_and_slide()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings:PackedStringArray = super._get_configuration_warnings()
	_check_warning_search(func(x): return x is MobEngine, null, get_children(), "This mob has no Engine. Consider adding a MobEngine as a child.", warnings)
		
	return warnings
	
	
