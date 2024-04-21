extends Behavior
class_name StabBehavior

var range = 1
var _target
@export var attack : CharacterAttack
var attack_animation = "1H_Melee_Attack_Stab"
var stab_time : int = 1000
var rate = 2
var limit_time : int

func check_execution(target : Node3D, delta):
	if object.mob.global_position.distance_squared_to(target.global_position) < range:
		return true
	return false
	
func start_execution(target : Node3D):
	_target = target
	object.mob.velocity = Vector3.ZERO
	object.mob.active_animation = { "name": attack_animation, "scale": rate, "start":null, "end":null}	
	limit_time = Time.get_ticks_msec() + (stab_time/rate)
	
func run_execution(delta):
	if Time.get_ticks_msec() < limit_time:
		return true
	return false
	
func finish_execution():
	_target.character_sheet.apply_hit(object.mob.character_sheet, attack)
	_target = null
