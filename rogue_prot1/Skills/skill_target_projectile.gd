extends Skill
class_name SkillTargetProjectile

@export var attack : CharacterAttack
@export var projectile : PackedScene

var state_time

@export var animation_name : String = "1H_Ranged_Shoot"
@export var skill_time : int = 1000
@export var rate : float = 1
@export var shoot_time : int = 400
var limit_time : int
var next_shoot : int

func enter_skill(object_to_run, skill_target = null):
	super.enter_skill(object_to_run, skill_target)	
	state_time = Time.get_ticks_msec()	
	actor.active_animation = { "name": animation_name, "scale": rate, "start":0, "end":1000}
	limit_time = state_time + (skill_time/rate)
	next_shoot = state_time + (shoot_time/rate)	
	
func _process_skill(_delta:float, _channeling : float = false):
	var time = Time.get_ticks_msec()
	if time > limit_time:
		return 1
		
	if time > next_shoot:
		next_shoot += (skill_time / rate)
		shoot()
		
	return 0

func shoot():
	var new_proj = projectile.instantiate()
	var dir : Vector3 = target.global_position - actor.global_position
	
	dir = dir.normalized()
	
	dir.y += 0.05
	
	new_proj.velocity = dir.normalized()
	new_proj.position = actor.global_position
	new_proj.target = target
	new_proj.actor = actor
	new_proj.attack = attack
	
	get_tree().get_root().add_child(new_proj)
