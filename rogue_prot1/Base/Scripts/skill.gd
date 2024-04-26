extends Node
class_name Skill

var actor : CharacterBase
var target

func enter_skill(skill_actor : CharacterBase, skill_target = null):
	actor = skill_actor
	target = skill_target
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process_skill(_delta, _channeling : float = false):
	pass
