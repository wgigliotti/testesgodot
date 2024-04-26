extends Skill
class_name SkillStab
@export var attack : CharacterAttack



var animation_name = "1H_Melee_Attack_Stab"
var stab_time : int = 1000
var rate = 2

var state_time

var limit_time : int


func enter_skill(object_to_run, skill_target = null):
	super.enter_skill(object_to_run, skill_target)	
	state_time = Time.get_ticks_msec()	
	actor.active_animation = { "name": animation_name, "scale": rate, "start":0, "end":1000}
	limit_time = Time.get_ticks_msec() + (stab_time/rate)
	
	
func _process_skill(_delta:float, _channeling : float = false):
	if Time.get_ticks_msec() < limit_time:
		return 0
	
	RulesBook.apply_attack(actor.get_character_sheet(), target.get_character_sheet(), attack)
	
	return 1
