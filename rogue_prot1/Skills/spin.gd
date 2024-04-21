extends Skill
class_name SkillSpin
@export var attack : CharacterAttack
@export var key : String = "ui_jump"

var speed_scale = 4
var start_animation = 0.7
var end_animation = 1.25
var animation_name = "2H_Melee_Attack_Spin"

var state_time

var damage_time = (end_animation - start_animation)*1000 / speed_scale

func enter_skill(object_to_run):
	super.enter_skill(object_to_run)	
	state_time = Time.get_ticks_msec()
	actor.moving = false
	actor.target_velocity = Vector3.ZERO
	actor.active_animation = { "name": animation_name, "scale": speed_scale, "start":start_animation, "end":end_animation}
	
	
func _process_skill(delta:float):
	var current_time = Time.get_ticks_msec() - state_time
	
	if !Input.is_action_pressed(key):		
		return 1
	
	if current_time > damage_time:		
		state_time = Time.get_ticks_msec()		
		apply_damage()
		
	actor.move(0.5, delta)
	
func apply_damage():
	var area : Area3D = actor.get_signature_area()
	for mob in area.get_overlapping_bodies():
		if mob.is_in_group("mobs"):
			mob.character_sheet.apply_hit(actor.character_sheet, attack)
