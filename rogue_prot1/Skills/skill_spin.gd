extends Skill
class_name SkillSpin

@export var attack : CharacterAttack
@export var radius  : float = 1
@export var tps : float = 1

var speed_scale = 4
var start_animation = 0.7
var end_animation = 1.25
var animation_time = end_animation - start_animation
var animation_name = "2H_Melee_Attack_Spin"
var active_tps : float

var state_time : int
var radius_square : float

var damage_time = (end_animation - start_animation)*1000 / speed_scale

func enter_skill(object_to_run : CharacterBase, skill_target = null):	
	super.enter_skill(object_to_run, skill_target)	
	radius_square = radius * actor.get_character_sheet().get_value(constants.CharacterAttributes.RANGE_CHANGE)
	radius_square = radius_square * radius_square
	
	active_tps = tps * actor.get_character_sheet().get_value(constants.CharacterAttributes.ATTACK_SPEED_CHANGE)		
	speed_scale = active_tps * animation_time
	damage_time = animation_time / speed_scale
	
	print(speed_scale)
	state_time = Time.get_ticks_msec()
	actor.active_animation = { "name": animation_name, "scale": speed_scale, "start":start_animation, "end":end_animation}
	
	
func _process_skill(delta:float, channeling : float = false):
	var current_time = Time.get_ticks_msec() - state_time
	
	if ! channeling:		
		return 1
	
	if current_time > damage_time:	
		
		state_time = Time.get_ticks_msec() + 1000/active_tps
		apply_damage()
		
	actor.move(0.5, delta, actor.getDirection())
	
func apply_damage():
	print("Damage dist: " +str( radius_square))
	var area : Area3D = actor.get_vision()
	for mob in area.get_overlapping_bodies():
		print("DD" + str(actor.global_position.distance_squared_to(mob.global_position)))
		if mob.is_in_group("mobs") and actor.global_position.distance_squared_to(mob.global_position) < radius_square:
			RulesBook.apply_attack(actor.get_character_sheet(), mob.get_character_sheet(), attack)

