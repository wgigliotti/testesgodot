extends Behavior
class_name StabBehavior

var stab_range = 1
var _target
@export var attack : CharacterAttack
var attack_animation = "1H_Melee_Attack_Stab"
var stab_time : int = 1000
var rate = 2
var limit_time : int

@export var skill : Skill

func check_execution(target : Node3D, _delta):
	if object.mob.global_position.distance_squared_to(target.global_position) < stab_range:
		return true
	return false
	
func start_execution(target : Node3D):
	skill.enter_skill(object.mob, target)
	_target = target
	object.mob.velocity = Vector3.ZERO	
	
func run_execution(delta):
	var response = skill._process_skill(delta, false)
	if response:
		return false
	return true
	
func finish_execution():	
	_target = null
