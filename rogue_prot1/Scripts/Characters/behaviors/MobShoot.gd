extends Behavior
class_name ShootBehavior

@export var skill : Skill
@export var projectile : PackedScene

var target_range = 25*25
var _target


func check_execution(target : Node3D, _delta):
	if object.mob.global_position.distance_squared_to(target.global_position) < target_range:
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
