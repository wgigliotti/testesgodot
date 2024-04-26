extends Skill
class_name SkillFlamestrike

@export var attack : CharacterAttack
@export var flamestrikeScene : PackedScene
@export var tps : float = 1

var speed_scale = 2

var animation_name = "Spellcast_Shoot"
var animation_time : float = 0.933
var flame_time = 450

var skill_time = 933 / speed_scale  
var next_flame
var active_tps : float

var state_time

func find_target():
	var area : Area3D = actor.get_vision()
	var min_target = null
	var min_dist
	
	for target_candidate in area.get_overlapping_bodies():		
		if target_candidate.is_in_group("mobs") and target_candidate.dead == false:
			var dist = actor.global_position.distance_squared_to(target_candidate.global_position)
			if min_target == null or dist < min_dist:
				min_target = target_candidate
				min_dist = dist
			
	target = min_target
	
	
	
	
func enter_skill(object_to_run, skill_target = null):	
	super.enter_skill(object_to_run, skill_target)	
	find_target()
	state_time = Time.get_ticks_msec()
	active_tps = tps * actor.get_character_sheet().get_value(constants.CharacterAttributes.ATTACK_SPEED_CHANGE)		
	speed_scale = active_tps * animation_time
	
	next_flame = flame_time / speed_scale
	skill_time = 933 / speed_scale 
	
	actor.active_animation = { "name": animation_name, "scale": speed_scale, "start":null, "end":null}
	if target:		
		actor.get_pivot().look_at(target.global_position, Vector3.UP)
	
	
func _process_skill(delta:float, channeling : float = false):
	if target == null: 
		return 1
	
	var current_time = Time.get_ticks_msec() - state_time	
	
	if current_time > next_flame:
		print("tacar fogo")
		next_flame += skill_time
		apply_flamestrike()
		
	if current_time > skill_time:
		return 1
		
	actor.velocity = Vector3.ZERO
	
	
func apply_flamestrike():
	var flamestrike = flamestrikeScene.instantiate()
	flamestrike.global_position = target.global_position
	flamestrike.actor = actor
	flamestrike.attack = attack
	
	get_tree().get_root().add_child(flamestrike)

