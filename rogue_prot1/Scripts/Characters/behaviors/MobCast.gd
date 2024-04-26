extends Behavior
class_name CastBehavior

var target_range = 20*20
var _target
@export var attack : CharacterAttack
@export var projectile : PackedScene
var attack_animation = "Spellcast_Raise"
var stab_time : int = 2100
var rate : float = 2
var limit_time : int

func check_execution(target : Node3D, _delta):
	if object.mob.global_position.distance_squared_to(target.global_position) < target_range:
		return true
	return false
	
func start_execution(target : Node3D):
	_target = target
	object.mob.velocity = Vector3.ZERO
	object.mob.active_animation = { "name": attack_animation, "scale": rate, "start":null, "end":null}	
	limit_time = Time.get_ticks_msec() + int(float(stab_time)/rate)
	var ball = projectile.instantiate()
	var dir : Vector3 = target.global_position - object.mob.global_position
	var dist = dir.length()
	dir = dir.normalized()
	
	dir.y += randf_range(0, 0.05)*dist
	dir.z += randf_range(-0.04, 0.04)*dist
	dir.x += randf_range(-0.04, 0.04)*dist
	ball.velocity = dir.normalized()
	ball.position = object.mob.global_position
	ball.target = target
	ball.actor = object.mob
	ball.attack = attack
	get_tree().get_root().add_child(ball)
	
func run_execution(_delta):
	if Time.get_ticks_msec() < limit_time:
		return true
	return false
	
func finish_execution():	
	_target = null
